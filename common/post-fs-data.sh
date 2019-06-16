#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode

# exec >"/cache/busybox_magisk.log"
# exec 2>&1

BB="$(which busybox)"

ln_bb() {
  local applet="$("$BB" basename "$1")"
  local basedir="$("$BB" dirname "$1")"
  local applet_path

  if [ ! \( -f "/$basedir/$applet" -o -f "/system/$basedir/$applet" \) ]; then
    # Some devices don't have directories like /system/sbin and
    # let Magisk "magic mount" them may cause stuck on boot
    # So we use rootfs as a backup
    if [ -d "/$basedir" ]; then
      applet_path="/$basedir/$applet"

      "$BB" ln -s "$BB" "$applet_path"
      chcon -Rh 'u:object_r:rootfs:s0' "$applet_path"
    elif [ -d "/system/$basedir" ]; then
      applet_path="$MODDIR/system/$basedir/$applet"

      "$BB" mkdir -p "$BB" "$MODDIR/system/$basedir"
      "$BB" ln -s "$BB" "$applet_path"
      chcon -Rh 'u:object_r:system_file:s0' "$applet_path"
    fi

    if [ -n "$applet_path" ]; then
      "$BB" chown -Rfh 0 "$applet_path"
      "$BB" chgrp -Rfh 0 "$applet_path"
      "$BB" chmod -Rf 755 "$applet_path"
    fi
  fi
}

ln_bb 'bin/busybox'

for applet in $("$BB" --list-full); do
  ln_bb "$applet"
done
