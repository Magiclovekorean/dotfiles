#!/usr/bin/env bash
set -euo pipefail

reuse=0

# Ask for hostname
read -rp "Enter hostname: " user_hostname
[[ -n "$user_hostname" ]] || { echo "hostname cannot be empty" >&2; exit 1; }

if [[ -d "hosts/$user_hostname" ]]; then
    echo "hosts/$user_hostname already exists. What do you want to do?"
    echo "  1) Reuse it (keep the existing files, only regenerate hardware-configuration.nix)"
    echo "  2) Remove it and set it up from scratch"
    echo "  3) Quit"
    read -rp "Choice [1-3]: " choice
    case "$choice" in
        1) reuse=1 ;;
        2) rm -rf "hosts/$user_hostname" ;;
        *) echo "aborting" >&2; exit 1 ;;
    esac
fi

if (( reuse )); then
    # Keep the committed host files as they are; only the username is needed here
    username=$(tr -d '[:space:]' < "hosts/$user_hostname/username")
    [[ -n "$username" && "$username" != "<USERNAME>" ]] || { echo "hosts/$user_hostname/username is not set" >&2; exit 1; }
else
    # Add device to hosts/
    cp -r hosts/example "hosts/$user_hostname"
    sed -i "s/<HOSTNAME>/$user_hostname/g" hosts/$user_hostname/*.nix
fi

# Generate hardware-configuration.nix and move it to dotfiles dir
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix "hosts/$user_hostname/hardware-configuration.nix"

if (( ! reuse )); then
    # Ask for username
    read -rp "Enter username: " username
    [[ -n "$username" ]] || { echo "username cannot be empty" >&2; exit 1; }

    # Ask for git identity
    read -rp "Enter git name: " git_name
    [[ -n "$git_name" ]] || { echo "git name cannot be empty" >&2; exit 1; }
    read -rp "Enter git email: " git_email
    [[ -n "$git_email" ]] || { echo "git email cannot be empty" >&2; exit 1; }
fi

# Write hostname/username into the target's home dir
mkdir -p "/mnt/home/$username"
echo "$user_hostname" > "/mnt/home/$username/.hostname"
echo "$username" > "/mnt/home/$username/.username"

if (( ! reuse )); then
    # Substitute the username into the copied host; the flake reads
    # hosts/<host>/username at evaluation time
    sed -i "s/<USERNAME>/$username/g" "hosts/$user_hostname/username" hosts/$user_hostname/*.nix

    # Substitute the git identity; same pattern, separate files
    sed -i "s/<GITNAME>/$git_name/g" "hosts/$user_hostname/git-name"
    sed -i "s/<GITEMAIL>/$git_email/g" "hosts/$user_hostname/git-email"
fi

# Git add the new host so the flake includes it. Running as root against a
# repo owned by another user would trip git's "dubious ownership" check.
git config --global --add safe.directory "$PWD"
if (( reuse )); then
    git add "hosts/$user_hostname/hardware-configuration.nix"
else
    git add .
fi

# Enable zram for compiling things like waybar
modprobe zram
zram_path=$(zramctl --find --size 4G)
mkswap "$zram_path"
swapon -p 100 "$zram_path"

# Install NixOS with flake and create password for the user,
# nixos-install will ask for the root password
nixos-install --flake ".#$user_hostname"
echo "Setting password for $username user"
nixos-enter --root /mnt -c "passwd $username"

# Give necessary permissions to the user
nixos-enter --root /mnt -c "cd /home/$username/Desktop/repos/dotfiles && chown -R $username:users . && chown -R $username:users .. && chown -R $username:users ../.."


read -rp "Do you want to reboot? (Y/n) " answer

if [[ "$answer" != "n" && "$answer" != "N" ]]; then
    reboot now
fi
