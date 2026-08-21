# My current setup for arch linux + hyprland

## About
These are the dotfiles I use primarily on arch linux. 
The dotfiles contain config for nvim, hyprland and sway(hyprland is much better configured and has much more features, it's the compositor I use the most,
however, I sometimes enjoy the minimalism I can achive with sway), openrazer, tmux, etc.

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


- The wallpapers I have are [Archie Chrisanthou's Digitally Painted Desktop Wallpapers](https://archdrawsalot.gumroad.com/l/arcnar), I have them In ~/Desktop/walls/ move the wallpapers of your choice there and change ~/.config/hypr/hyprpaper.conf to modify the path option.

    - To install the majority of the packages, I whould follow along [josean](www.youtube.com/@joseanmartinez)'s arch+hyprland+waybar video series.

