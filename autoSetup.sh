#!/usr/bin/env bash

# Ensure repos directory is created
if [ ! -d "$HOME/Desktop/repos" ]; then
    echo "You don't have the ~/Desktop/repos directory, create it and move this repo to ~/Desktop/repos/dotfiles"
    exit 1
fi

cd ~/Desktop/repos/dotfiles

#TODO: Uncomment this
#sudo pacman -Syu

# TODO: Uncomment this
# Install all packages installed via pacman
sudo pacman -S stow unzip yazi fzf uwsm hyprland ghostty noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji ttf-liberation ttf-dejavu mako pipewire wireplumber pipewire-audio pipewire-pulse pipewire-jack pavucontrol xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland ttf-jetbrains-mono-nerd glow python python-pip lazygit tmux xclip wl-clipboard zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search rust eza bat clang satty nemo imv mpv vlc spotify-launcher rofi rofi-calc rofi-emoji cliphist playerctl brightnessctl nwg-look gnome-themes-extra qt6ct qt5ct obs-studio inotify-tools python-setuptools blueman bluetui btop htop hyprpaper hyprpicker hypridle hyprlock hyprsunset hyprshutdown grim tesseract slurp

#TODO: Uncomment this
# Install fnm and pnpm
#curl -fsSL https://fnm.vercel.app/install | bash
#fnm install --lts
#fnm default lts-latest
#corepack enable pnpm

#TODO:Uncomment this
# Install treesitter-cli
#cargo install --locked tree-sitter-cli
#Install nmrs-gui
#cargo install nmrs-gui
rm -rf ~/.cargo/registry
rm -rf ~/.cargo/git

# TODO:
# Install tpm(tmux plugin manager)
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Rebuild the font cache so newly installed fonts are detected by applications
#TODO: Uncomment this
#fc-cache -fv

# Stow dotfiles
stow -t ~ .

#TODO: Uncomment this
# Make zsh default shell
#chsh -s /usr/bin/zsh

#TODO: Uncomment this
#Fix zsh error related to zcompdump.zwc
#mkdir -p "$HOME/.config/zsh"
#chown -R "$(id -u):$(id -g)" "$HOME/.config/zsh"

#TODO: Uncomment this
# Install fzf-tab zsh plugin
#sudo mkdir -p /usr/share/zsh/plugins/fzf-tab
#sudo git clone https://github.com/Aloxaf/fzf-tab.git /usr/share/zsh/plugins/fzf-tab

#TODO: Uncomment this
# Install sudo zsh plugin
#mkdir -p ~/.config/zsh/plugins
#curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh \
#  -o ~/.config/zsh/plugins/sudo.plugin.zsh

# TODO: Uncomment this
# Install nix and home-manager
#curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
#nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
#nix-channel --update
#nix-shell '<home-manager>' -A install
#nix-channel --update && home-manager switch


#TODO: Uncomments this 
#Make scripts executables
#chmod +x bin/*
#sudo cp bin/* /usr/local/bin/
chmod +x .config/waybar/custom_modules/*/*.sh
chmod +x .config/hypr/scripts/* 

#TODO: Uncomment this
# Generate rofi config and select theme
#mkdir -p ~/.config/rofi
#rofi -dump-config > ~/.config/rofi/config.rasi
#cd ~/Desktop/repos/
#git clone https://github.com/lr-tech/rofi-themes-collection.git
#cd rofi-themes-collection
#mkdir -p ~/.local/share/rofi/themes/
#cp -r themes/* ~/.local/share/rofi/themes/
#    rofi-theme-selector


cd ~/Desktop/repos/dotfiles

#TODO: Uncomment this
# Open qt5ct and qt6ct to let the user choose the desired colorscheme for qt5 and qt6 apps
#qt5ct
#qt6ct

#TODO: Uncomment this
# Open nwg-look to let the user choose the desired colorscheme for gtk and qt6 apps
#nwg-look

systemctl --user enable --now hyprpolkitagent.service

# Install yay aur helper
if ! command -v yay >/dev/null 2>&1; then
	cd ~/Desktop/repos
	sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
	cd ..
	rm -rf yay
	cd ~/Desktop/repos/dotfiles
fi

# TODO: Uncomment this
#yay -S brave-origin-bin zen-browser-bin waybar-git rose-pine-cursor


echo "This script didn't install zscroll, the reason why it doesn't is because I prefer to manually do it and check the security of the package, you'll have to install it"
