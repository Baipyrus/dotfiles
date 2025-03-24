#!/bin/bash

if ! grep -q -E 'for .* in .*\.bashrc\.d' ~/.bashrc; then
    echo '. "$HOME/.bashrc.d/init.sh"' >> ~/.bashrc
fi

mkdir -p ~/.bashrc.d
cp -f ./bashrc.d/* ~/.bashrc.d/

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
