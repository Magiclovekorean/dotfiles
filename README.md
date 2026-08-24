# My current setup for Arch Linux + Hyprland

## About
These are the dotfiles I use primarily on arch Linux. 
The dotfiles contain config for Neovim, Hyprland and Sway(hyprland is much better configured and has much more features, it's the compositor I use the most,
however, I sometimes enjoy the minimalism I can achive with Sway), openrazer, tmux, etc.

## Instalation
I made an autoSetup script that does everything automaticly for you:
```bash
chmod +x autoSetup.sh
./autoSetup.sh
```

If you just want to stow the dotfiles, run

```bash
stow -t ~ .
```
This will symlink all these dotfiles to the home directory. 


- The wallpapers I have are [Archie Chrisanthou's Digitally Painted Desktop Wallpapers](https://archdrawsalot.gumroad.com/l/arcnar) an everforest wallpaper form pixie-sddm theme and [this wallpaper from wallhaeven](https://wallhaven.cc/w/vgyyxl), I have them In ~/Desktop/walls/ move the wallpapers of your choice there and change ~/.config/hypr/hyprpaper.conf to modify the path option.


