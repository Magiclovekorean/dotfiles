#!/usr/bin/env bash

# Generate hardware-configuration.nix and move it to dotfiles dir
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix .

# Enable zram for compiling things like waybar
modprobe zram
zram_path=$(zramctl --find --size 4G)
mkswap "$zram_path"
swapon -p 100 "$zram_path"

# hardware-configuration.nix is machine-specific and intentionally
# excluded from the Git repository.
echo "hardware-configuration.nix" >> .git/info/exclude

# Install NixOS with flake and create password for magictt user, 
# nixos-install will ask for the root password
nixos-install --flake .#nixos-flake
nixos-enter --root /mnt -c 'passwd magictt'

read -p "Do you want to reboot? (Y/n) " answer

if [[ "$answer" != "n" && "$answer" != "N" ]]; then
    reboot now
fi

