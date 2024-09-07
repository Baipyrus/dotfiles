# Dotfiles

Welcome to my `dotfiles` repository! This repository contains the configuration files
for various programs I use. Each program's configuration is organized into its own
directory. Below is a brief overview of the programs and configurations included.

## Structure

- **PowerShell**: [PowerShell configuration](./PowerShell)
- **alacritty**: [Alacritty terminal emulator configuration](./alacritty)
- **nerd-fonts**: [Nerd Fonts installation](./nerd-fonts)
- **nvim**: [Neovim configuration](./nvim)

## Installation

To use these configurations, clone this repository and copy or symlink the necessary
files to your home directory or the appropriate configuration directories for each
program. Instructions for each program are provided in their respective directories.

```pwsh
git clone https://github.com/Baipyrus/dotfiles.git
```

Alternatively, feel free to run the [install script](./install_windows.ps1) after
cloning the repository or directly execute it from shell:

```pwsh
# Using 'Invoke-RestMethod' and 'Invoke-Expression'
irm 'https://raw.githubusercontent.com/Baipyrus/dotfiles/main/install_windows.ps1' | iex
```
