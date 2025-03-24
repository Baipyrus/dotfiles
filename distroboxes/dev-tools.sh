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

# Install configs (nvim/alacritty)
git clone https://github.com/Baipyrus/nvim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
sudo mkdir -p /usr/share/pixmaps/
wget -P "${XDG_CONFIG_HOME:-$HOME/.config}"/alacritty https://raw.githubusercontent.com/Baipyrus/dotfiles/refs/heads/main/alacritty/alacritty_linux.toml
wget -P "${XDG_CONFIG_HOME:-$HOME/.config}"/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-latte.toml
wget -P "${XDG_CONFIG_HOME:-$HOME/.config}"/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

# Export apps
distrobox-export -a alacritty
distrobox-export -a neovide
distrobox-export -b /usr/bin/neovide
distrobox-export -b /usr/bin/nvim
