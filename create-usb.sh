#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "Run $0 as root"
    exit
fi

# Get the passphrase for the encrypted volume
read -sp "Enter passphrase for the encrypted volume: " passphrase
echo
passphrase=${passphrase:?"password cannot be empty"}
read -sp "Confirm passphrase: " check
echo
if [[ "$passphrase" != "$check" ]]; then
    echo "Passwords did not match" >&2
    exit 1
fi

# Get the USB device
echo -e "\nWhich device do you want to use?"
lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop"
devicelist=$(lsblk -dplnx size -o name | grep -Ev "boot|rpmb|loop")
echo
read -p "Enter the full device name: " device
if echo $devicelist | grep -vwq $device; then
    echo "$device is not in the device list" >&2
    exit 1
fi


# Set a known UUID for auto-mounting the drive
uuid="8309b1c2-21a0-48e5-bc09-977ec5cd430d"
keys=${device}3
iso=$(ls out | grep -e "iso$" | head -1)


# Wipe the existing USB key
echo -e "\nWiping disk ${device}"
lsblk -plnx size -o name "${device}" | xargs -n1 wipefs --all

# Load the ISO onto the key
echo -e "\nLoading ${iso} onto ${device}"
dd if=out/"${iso}" of="${device}" bs=4M status=progress
sync

# Create a new 2G partition on the end of the key to store the encrypted data
echo -e "\nCreating a new 2G partition on ${device}"
sfdisk --wipe=never --append $device <<EOF
label: dos
${keys}: size=4194304, type=83
EOF

echo -e "\nEncrypting ${keys}"
echo -n ${passphrase} | cryptsetup luksFormat \
    --type luks2 \
    --pbkdf argon2id \
    --label keys \
    "${keys}"

echo -n ${passphrase} | cryptsetup open "${keys}" keys

echo -e "\nFormatting ${keys} with the ext4 filesystem"
mkfs.ext4 -L keys /dev/mapper/keys

echo -e "\nClosing encrypted partition"
sleep 2
cryptsetup close keys

echo -e "\nSetting disk UUID to ${uuid} for mounting purposes"
cryptsetup -q luksUUID ${keys} --uuid ${uuid}

echo -e "\nDone"
