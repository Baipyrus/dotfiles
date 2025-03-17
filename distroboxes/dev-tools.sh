#!/bin/bash
# Create container using:
# distrobox create -n dev-tools -p -i ghcr.io/ublue-os/fedora-toolbox
# distrobox enter -n dev-tools

# Install programs and sdks
sudo dnf install -y gcc make fd-find \
    neovim dotnet-sdk-8.0 golang composer \
    nodejs-npm libxkbcommon alacritty

# Install neovide
sudo mkdir -p /usr/local/bin
wget -P /tmp/ https://github.com/neovide/neovide/releases/latest/download/neovide-linux-x86_64.tar.gz
sudo tar -xvzf /tmp/neovide-linux-x86_64.tar.gz -C /usr/bin/
sudo chmod +x /usr/bin/neovide
sudo chown root: /usr/bin/neovide

# Install neovide desktop file
wget -P /tmp/ https://raw.githubusercontent.com/neovide/neovide/main/assets/neovide.desktop
sudo desktop-file-install /tmp/neovide.desktop

# Install neovide app icon
sudo mkdir -p /usr/share/pixmaps/
wget -P /tmp/ https://raw.githubusercontent.com/neovide/neovide/main/assets/neovide.svg
sudo cp /tmp/neovide.svg /usr/share/pixmaps/
cp /tmp/neovide.svg ~/.local/share/icons/

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
