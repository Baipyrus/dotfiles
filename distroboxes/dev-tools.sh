#!/bin/bash
# Create container using:
# distrobox create -n dev-tools -p -i quay.io/fedora/fedora:41
# distrobox enter -n dev-tools

# Install Fyra Labs Terra repository
sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Install programs and sdks
sudo dnf install -y gcc make git ripgrep fd-find unzip \
    neovide neovim dotnet-sdk-8.0 golang composer wget \
    nodejs-npm alacritty fontconfig libxkbcommon \
    libxkbcommon-x11 libwayland-egl libglvnd-egl

# Clone Neovim config
CFG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}"
if [ -d $CFG_PATH/nvim ]; then
    git -C $CFG_PATH/nvim pull
else
    git clone https://github.com/Baipyrus/nvim-config.git $CFG_PATH/nvim
fi

# Download Alacritty configs
wget -P $CFG_PATH/alacritty https://github.com/Baipyrus/dotfiles/raw/main/alacritty/alacritty_linux.toml
wget -P $CFG_PATH/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-latte.toml
wget -P $CFG_PATH/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

# Export apps
distrobox-export -a alacritty
distrobox-export -a neovide
distrobox-export -b /usr/bin/neovide
distrobox-export -b /usr/bin/nvim
