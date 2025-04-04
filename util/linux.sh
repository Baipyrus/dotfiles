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
cp -f alacritty/alacritty_linux.toml $CFG_PATH/alacritty/alacritty.toml
rm -f $CFG_PATH/alacritty/catppuccin*
wget -P $CFG_PATH/alacritty $(cat alacritty/catppuccin-latte.url)
wget -P $CFG_PATH/alacritty $(cat alacritty/catppuccin-mocha.url)
