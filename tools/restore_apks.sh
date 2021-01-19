#!/bin/bash
# Restore all apk's in current folder, including
# multi-apk apps which have their many apks in
# their respective folders, as pulled from your phone
# using the "getapk.sh" script. Installation is done only for
# "Owner" user (user 0). Intended for user apps only.


if [ $# -gt 0 ]
then
	echo -e "\n\033[1;37mrestore_apks\033[0m\n"
	echo "**Restoring APKs to connected device**"
	echo " "
	echo "Usage: Install all APK's in current folder to"
	echo "connected device, including split APK's, which"
	echo "consist of multiple apk's in their respective"
	echo "folders, as extracted by the getapk script."
	echo "Only installs apps to Owner user (user 0)"
	echo "Intended for user apps only."
	echo " "
	exit;
fi

# This option is for preventing the loop from evaluating its body
# for "*.apk", in case no actual apk's exist to match the wildcard
shopt -s nullglob
for i in *.apk; do
    adb install --user 0 "$i"
done
for directory in */ ; do
    multipath="$directory*.apk"
    adb install-multiple --user 0 $multipath
done