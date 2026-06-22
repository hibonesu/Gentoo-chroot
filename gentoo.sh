#!/bin/sh

# Jalur utama chroot Gentoo di folder tmp
mnt="/data/local/tmp/gentoo"

# Pastikan folder tujuan di luar /dev sudah dibuat sebelum di-mount
mkdir -p "$mnt/dev" "$mnt/proc" "$mnt/sys" "$mnt/media/storage" "$mnt/media/sdcard" "$mnt/var/cache"

safe_mount() {
    type=$1
    src=$2
    dst=$3
    options=$4

    if ! mountpoint -q "$dst"; then
        if [ "$type" = "bind" ]; then
            busybox mount -o bind "$src" "$dst"
        else
            busybox mount -t "$type" $options "$src" "$dst"
        fi
    fi
}

# Proses Mounting
safe_mount "bind" /dev "$mnt/dev"
safe_mount "proc" proc "$mnt/proc" ""
safe_mount "sysfs" sysfs "$mnt/sys" ""
safe_mount "devpts" devpts "$mnt/dev/pts" ""
safe_mount "bind" /sdcard "$mnt/media/storage"
safe_mount "bind" /storage/4572-1409 "$mnt/media/sdcard"
safe_mount "tmpfs" tmpfs "$mnt/var/cache" ""
safe_mount "tmpfs" tmpfs "$mnt/dev/shm" "-o size=256M"

# Masuk ke lingkungan Chroot Gentoo sebagai Root menggunakan Bash Login Shell
chroot "$mnt" /bin/su - root

# Proses Pembersihan (Unmount otomatis setelah kamu ketik 'exit')
busybox umount -l "$mnt/var/cache" 2>/dev/null
busybox umount -l "$mnt/media/sdcard" 2>/dev/null
busybox umount -l "$mnt/media/storage" 2>/dev/null
busybox umount -l "$mnt/dev/pts" 2>/dev/null
busybox umount -l "$mnt/sys" 2>/dev/null
busybox umount -l "$mnt/proc" 2>/dev/null
busybox umount -l "$mnt/dev" 2>/dev/null

