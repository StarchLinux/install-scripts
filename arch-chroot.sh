#!/bin/mksh

. /lib/starch-install-scripts/common.sh

target="$1"; shift

test -d "$target" || {
	msg "$target is no directory"
}

trap api_fs_umount EXIT

api_fs_mount "$target" || {
	msg "Failed to mount API filesystems on $target"
	exit 1
}

cp /etc/resolv.conf "$target/etc/"

SHELL=/bin/mksh chroot "$target" "$@"
