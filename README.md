# Busybox of Magisk

Unlike [Busybox for Android NDK](https://github.com/Magisk-Modules-Repo/busybox-ndk), this module only contains a script exposing Magisk's internal `busybox` and installing applets. It doesn't carry the actual binary.

## Config Installion

The applets to install can be config by  a file `/sdcard/busybox-magisk.conf`. Place a line of `+<applet>` to force install an applet. Place a line of `-<applet>` to skip an applet.(Exclude the angle brackets) Anything else not match the patten will be ignored.

If an applet is not list in the config file, the installer will first search for it in `$PATH` and install it if not found.

Run `busybox --list` to get a full list of applets.
