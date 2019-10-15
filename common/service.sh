#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODPATH if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODPATH=${0%/*}

# This script will be executed in late_start service mode
