#!/bin/bash
# restoring an app backup obtained by root_appbackup.sh using root powers
#
# !!! WARNING !!!
# !!! This is totally untested. Use at your own risk !!!
# !!! DRAGONS !!! BOMBS !!! TOMATOES !!!
#
# If you're nuts enough to give this a try, please report your success.

# --=[ Syntax ]=--
[[ -z "$1" ]] && {
  echo -e "\n\033[1;37mroot_backup\033[0m"
  echo "Obtaining APK and data of a given app using root powers"
  echo
  echo "Syntax:"
  echo -e "  $0 <packageName> [sourceDirectory]\n"
  echo "Examples:"
  echo "  $0 com.foo.bar"
  echo -e "  $0 com.foo.bar backups\n"
  exit 1
}

# --=[ Parameters ]=--
BINDIR="$(dirname "$(readlink -mn "${0}")")" #"
pkg=$1
if [[ -n "$2" ]]; then
  if [[ -d "$2" ]]; then
    BACKUPDIR="$2"
  else
    echo -e "specified source directory '$2' does not exist, exiting.\n"
    exit 5
  fi
else
  BACKUPDIR="."
fi

# --=[ root-check ]=--
adb shell "su -c 'ls /data'" >/dev/null 2>&1
rc=$?
[[ $rc -ne 0 ]] && {
  echo -e "Sorry, looks like the device is not rooted: we cannot call to 'su'.\n"
  exit $rc
}

#--=[ check if all files are available ]=--
[[ ! -f "${BACKUPDIR}/user-${pkg}.tar" ]] && {
  echo -e "could not find '${BACKUPDIR}/user-${pkg}.tar', aborting.\n"
  exit 5
}
[[ ! -f "${BACKUPDIR}/user_de-${pkg}.tar" ]] && {
  echo -e "could not find '${BACKUPDIR}/user_de-${pkg}.tar', aborting.\n"
  exit 5
}
[[ ! -f "${BACKUPDIR}/${pkg}.apk" && ! -d "${BACKUPDIR}/${pkg}" ]] && {
  echo -e "could not find any APK for '$pkg' in '${BACKUPDIR}', exiting.\n"
  exit 5
}

# --=[ do the restore ]=--
USER_TAR="${BACKUPDIR}/user-${pkg}.tar"
USER_DE_TAR="${BACKUPDIR}/user_de-${pkg}.tar"

set -ex

# Install APK(s)
if [[ -f "${BACKUPDIR}/${pkg}.apk" ]]; then
    adb install "${BACKUPDIR}/${pkg}.apk"
elif [[ -d "${BACKUPDIR}/${pkg}" ]]; then
    multipath="${BACKUPDIR}/${pkg}/*.apk"
    adb install-multiple $multipath
else
    echo -e "Ooops! No APKs to install?\n"
    exit 99
fi

# Make sure the app closes and stays closed
adb shell "su -c 'pm disable $pkg'"
adb shell "su -c 'am force-stop $pkg'"
adb shell "su -c 'pm clear $pkg'"

# Restore data files
cat "$USER_TAR" | adb shell -e none -T "su -c 'tar xf -'"
cat "$USER_DE_TAR" | adb shell -e none -T "su -c 'tar xf -'"

# Remove cache contents
adb shell "su -c 'rm -rf /data/user{,_de}/0/${pkg}/{cache,code_cache}'"

# Adapt to new UID
PKGUID=$(adb shell "su -c \"pm list packages -U ${pkg} | cut -d':' -f3\"")
adb shell "su -c 'chown -R $PKGUID:$PKGUID /data/user/0/${pkg} /data/user_de/0/${pkg}'"

# Restore SELinux contexts
adb shell "su -c 'restorecon -F -R /data/user/0/${pkg}'"
adb shell "su -c 'restorecon -F -R /data/user_de/0/${pkg}'"

# Reenable package
adb shell "su -c 'pm enable $pkg'"
