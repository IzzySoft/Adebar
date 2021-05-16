#!/bin/bash
# obtaining a backup of any app using "root powers"

# --=[ Syntax ]=--
[[ -z "$1" ]] && {
  echo -e "\n\033[1;37mroot_backup\033[0m"
  echo "Obtaining APK and data of a given app using root powers"
  echo
  echo "Syntax:"
  echo -e "  $0 <packageName> [targetDirectory]\n"
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
    echo -e "specified target directory '$2' does not exist, exiting.\n"
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

# --=[ Performing the backup ]=--
echo "Backing up '$pkg' to directory: $BACKUPDIR"
${BINDIR}/getapk $pkg
[[ "$BACKUPDIR" != "." ]] && {
  if [[ -f "${pkg}.apk" ]]; then
    mv "${pkg}.apk" "$BACKUPDIR"
  elif [[ -d "$pkg" ]]; then
    mv "$pkg" "$BACKUPDIR"
  else
    echo -e "Ouch: could not obtain the APK for '$pkg', sorry…\n";
  fi
}
adb shell -e none -n -T "su -c 'tar cf - data/user/0/${pkg}'" >"${BACKUPDIR}/user-${pkg}.tar"
adb shell -e none -n -T "su -c 'tar cf - data/user_de/0/${pkg}'" >"${BACKUPDIR}/user_de-${pkg}.tar"
