#!/bin/mksh

. /lib/starch-install-scripts/common.sh

test "$#" -eq 0 && {
	msg "No target directory given"
	exit 1
}

target=$1; shift
test -d "$target" || {
	msg "$target is no directory"
	exit 1
}

install -dm 0755 "$target"/{dev,run,etc,var/{cache/pacman/pkg,lib/pacman,log}}
install -dm 1777 "$target"/tmp
install -dm 0555 "$target"/{sys,proc}

trap api_fs_umount EXIT

api_fs_mount "$target" || {
	msg "Failed to mount API filesystems on target"
	exit 1
}

msg "Installing packages to $target"
pacman --config "$target/etc/pacman.conf" --cachedir "$target/var/cache/pacman/pkg" -r "$target" -Sy "$@" || {
	msg "Failed to install packages"
	exit 1
}
