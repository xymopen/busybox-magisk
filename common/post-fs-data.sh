#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODPATH if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODPATH=${0%/*}

# This script will be executed in post-fs-data mode

# exec >"/cache/busybox_magisk.log"
# exec 2>&1

LAST_BBPATH="$MODPATH/bb.txt"
LAST_APPLETS_PATH="$MODPATH/applets.txt"

BB="$(which busybox)"
BBPATH="$(dirname "$BB")"
APPLETS=$("$BB" --list)

# Follow [busybox-ndk](https://github.com/Magisk-Modules-Repo/busybox-ndk
# "Magisk-Modules-Repo/busybox-ndk: busybox-ndk")
if [ -d "/system/xbin" ]; then
  BIN="xbin"
else
  BIN="bin"
fi

which_not_busybox() {
  local IFS=':'

  for i in $PATH; do
    if [ "$i" = "$BBPATH" ]; then
      continue
    fi

    if [ -x "$i/$1" ]; then
      echo "$i/$1"

      return 0
    fi
  done

  return 1
}

ln_bb() {
  # Some devices don't have directories like /system/sbin and
  # let Magisk "magic mount" them may cause stuck on boot
  # So we install applets to /system/(x)bin

  local applet="$1"
  local applet_path="$MODPATH/system/$BIN/$applet"

  ln -s "$BB" "$applet_path"

  chmod -f 755 "$applet_path"
  chown -fh 0 "$applet_path"
  chgrp -fh 0 "$applet_path"
  chcon -h 'u:object_r:system_file:s0' "$applet_path"
}

if [ \(											                  		\
  "$BB" != "$(cat "$LAST_BBPATH")" -o        	\
  "$APPLETS" != "$(cat "$LAST_APPLETS_PATH")" \
\) ]; then
  echo "$BB" > "$LAST_BBPATH"
  echo "$APPLETS" > "$LAST_APPLETS_PATH"

  # Shell script runs in non-interactive mode
  # in which extglob is not enabled
  rm -rf "$MODPATH/system/$BIN"
  mkdir -p "$MODPATH/system/$BIN"

  ln_bb 'busybox'

  for applet in $APPLETS; do
    if ! which_not_busybox "$applet" > /dev/null; then
      ln_bb "$applet"
    fi
  done
fi
