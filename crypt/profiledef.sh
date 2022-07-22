#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archlinux-crypt"
iso_label="ARCH_$(date +%Y%m)"
iso_publisher="James Coulson <arch@coulson.ie>"
iso_application="GPG and SSL creation and management tools"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux.mbr'
    'bios.syslinux.eltorito'
    'uefi-x64.grub.esp'
    'uefi-x64.grub.eltorito'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,12' -E ztailpacking)
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root/.gnupg"]="0:0:700"
)
