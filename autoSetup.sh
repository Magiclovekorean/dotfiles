#!/usr/bin/env bash

# Generate hardware-configuration.nix and move it to dotfiles dir
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix .

# Enable zram for compiling things like waybar
modprobe zram
zram_path=$(zramctl --find --size 4G)
mkswap "$zram_path"
swapon -p 100 "$zram_path"

git add hardware-configuration.nix

# Install NixOS with flake and create password for magictt user, 
# nixos-install will ask for the root password
nixos-install --flake .#nixos-flake
echo 'Setting password for magictt user'
nixos-enter --root /mnt -c 'passwd magictt'

# Give necessary permissions to magictt user
nixos-enter --root /mnt -c 'cd /home/magictt/Desktop/repos/dotfiles && chown -R magictt:users . && chown -R magictt:users .. && chown -R magictt:users ../..'


read -p "Do you want to reboot? (Y/n) " answer

if [[ "$answer" != "n" && "$answer" != "N" ]]; then
    reboot now
fi

