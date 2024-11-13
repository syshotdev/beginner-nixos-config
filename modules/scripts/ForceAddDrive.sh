# !/bin/bash

# Script for latching a stubborn drive to your filesystem
if [[ -z "$1" ]]
  echo "
  A utility to force add a hard drive
  Usage: $0 <drive_name> (This means sda1 not SAMDISK)"
  exit 1
fi

echo "script incomplete DON'T USE!"
exit 1
drive_filesystem_name=$1
# Incomplete. How do I find a drive name?
drive_name=$(lsblk)
username=$(whoami)

# Fix the ntfs filesystem (to hopefully fix whatever error you were having)
sudo ntfsfix "/dev/$drive_filesystem_name"
sudo mkdir "/run/media/$username/$drive_name"
sudo ntfs-3g "/dev/"$drive_filesystem_name"/run/media/$username/$drive_name -o force"
