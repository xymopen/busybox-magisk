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
BBPATH="$(dirname "$BB")"

mkdir -p "$MODDIR/system"
rm -rf "$MODDIR/system/*"
mkdir -p "$MODDIR/system/bin"

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
  # So we install applets to /system/bin

  local applet="$1"
  local applet_path="$MODDIR/system/bin/$applet"

  ln -s "$BB" "$applet_path"

  chmod -Rf 755 "$applet_path"
  chown -Rfh 0 "$applet_path"
  chgrp -Rfh 0 "$applet_path"
  chcon -Rh 'u:object_r:system_file:s0' "$applet_path"
}

ln_bb 'bin/busybox'

for applet in $("$BB" --list); do
  if ! which_not_busybox "$applet" > /dev/null; then
    ln_bb "$applet"
  fi
done
