# Dotfiles for NixOS+Hyprland for a keyboard-centric development and video editing workflow

## About
These are the dotfiles I use on NixOS
The dotfiles contain config for Neovim, Hyprland and Sway(hyprland is much better configured and has much more features, it's the compositor I use the most,
however, I sometimes enjoy the minimalism I can achive with Sway), openrazer, tmux, etc.

## Installation
1. Enter the minimal NixOS ISO
2. Escalate to root with
```bash
sudo -i
```
3. If not using ethernet, connect to network via `nmtui`
4. To locate the disk in which you want to install NixOS, run 
```bash
lsblk
```
5. Supposing the disk on which I want to install NixOS is `nvme0n1`, partition the disks, I use `cfdisk` to do so.
    Remove all partitions (if dualbooting with something like `Windows`, simply do NOT create a new `EFI` partition,
    don't format the one `Windows` created and mount it normally), create a 1G `EFI` partition with type `EFI` and 
    leave the remaining space for the `root partition`. 
6. Format the created partition as follows:
```bash
mkfs.ext4 -L nixos /path/to/root/partition
mkfs.fat -F 32 -n boot /path/to/efi/partition
```
7. Mount the formatted partitions as shown below:
```bash
mount /path/to/root/partition /mnt
mount --mkdir /path/to/efi/partition /mnt/boot
```
8. Move this repo to `/mnt`, I suggest `/mnt/home/magictt/Desktop/repos`
9. Use the `autoSetup.sh` script that does the remaining setup.
```bash
chmod +x autoSetup.sh
./autoSetup.sh
```

### Dualbooting with `Windows`
The process is almost the same to the normal instalation.

You have to keep the windowsprocess is almost the same to the normal instalation.

You have to keep the Windows

- The wallpapers I have are [Archie Chrisanthou's Digitally Painted Desktop Wallpapers](https://archdrawsalot.gumroad.com/l/arcnar) an everforest wallpaper form pixie-sddm theme and [this wallpaper from wallhaeven](https://wallhaven.cc/w/vgyyxl), I have them In ~/Desktop/walls/ move the wallpapers of your choice there and change ~/.config/hypr/hyprpaper.conf to modify the path option.

