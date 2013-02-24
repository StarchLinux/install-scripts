function msg {
	echo "$@" >&2
}

function mount_noted {
	mount "$@" && NOTED_MOUNTS=("$4" "${NOTED_MOUNTS[@]}")
}

function api_fs_mount {
	NOTED_MOUNTS=()
	mount_noted -t proc	_ "$1/proc"	-o nosuid,noexec,nodev		&&
	mount_noted -t sysfs	_ "$1/sys"	-o nosuid,noexec,nodev		&&
	mount_noted -t devtmpfs	_ "$1/dev"	-o mode=0755,nosuid		&&
	mount_noted -t devpts	_ "$1/dev/pts"	-o mode=0620,nosuid,noexec	&&
	mount_noted -t tmpfs	_ "$1/dev/shm"	-o mode=1777,nosuid,nodev	&&
	mount_noted -t tmpfs	_ "$1/run"	-o mode=0755,nosuid,nodev	&&
	mount_noted -t tmpfs	_ "$1/tmp"	-o mode=1777,nosuid,nodev
}

function api_fs_umount {
	umount "${NOTED_MOUNTS[@]}"
}
