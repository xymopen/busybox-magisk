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

# Magisk copies new files when update
# so skipping applets doesn't work
rm -rf "$MODPATH/system"
mv "$MODPATH/system.new" "$MODPATH/system"

rm -f "$MODPATH/post-fs-data.sh"
