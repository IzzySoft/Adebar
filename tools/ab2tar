#!/usr/bin/env bash
# convert ADB Backups to tar

[[ -z "$1" ]] && {
  echo -e "\n\033[1;37mab2tar\033[0;37m"
  echo "Converting ADB Backup files into tar.gz archives"
  echo
  echo "Syntax:"
  echo -e "  $0 <ADB Backup File>\n"
  echo "Example:"
  echo -e "  $0 com.foo.bar.ab\n"
  exit 1
}

if [[ "$(ldd "$(which openssl)" | grep '^[[:space:]]*libz\.')" ]]; then
    unzlib="openssl zlib -d"
else
    unzlib="zlib-flate -uncompress"
fi

dd if="$1" bs=24 skip=1 | $unzlib | gzip -9 -c > "${1%%.ab}".tar.gz
