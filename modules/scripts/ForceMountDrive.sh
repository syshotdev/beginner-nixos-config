# !/bin/bash

# Script for latching a stubborn drive to your filesystem
if [[ -z "$1" ]]; then
  echo "
  A utility to force add a hard drive
  Usage: $0 <drive_sd_name><-(This means sda1 not SAMDISK) <drive_name>"
  exit 1
fi

drive_filesystem_name=$1
drive_name=$2
username=$(whoami)

# Fix the ntfs filesystem (to hopefully fix whatever error you were having)
sudo ntfsfix "/dev/$drive_filesystem_name"
# Make mounting point directory
sudo mkdir "/run/media/$username/$drive_name"
# Mount /dev/sd? to /run/media/username/drive_name
sudo ntfs-3g "/dev/$drive_filesystem_name" "/run/media/$username/$drive_name" -o force
