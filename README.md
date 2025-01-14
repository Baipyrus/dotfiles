# Dotfiles

Welcome to my `dotfiles` repository! This repository contains the configuration files
for various programs I use. Each program's configuration is organized into its own
directory. Below is a brief overview of the programs and configurations included.

## Structure

- **PowerShell**: [PowerShell configuration](./PowerShell)
- **alacritty**: [Alacritty terminal emulator configuration](./alacritty)
- **nerd-fonts**: [Nerd Fonts installation](./nerd-fonts)
- **nvim**: [Neovim configuration](./nvim)

## Prerequisites

While the installation of these dotfiles may not require the use of any external
tools, it is still necessary to install all the main applications that are being
configured, as seen in [Structure](#structure), and other tools needed for development.
These tools could be optionally installed automatically during runtime.

> **NOTE**
> For more information, simply see all [util/](./util) installation modules.

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
irm https://api.github.com/repos/Baipyrus/dotfiles/zipball -O "$env:TMP\dotfiles.zip"
Expand-Archive "$env:TMP\dotfiles.zip" -D "$env:TMP\dotfiles" -F
gci "$env:TMP\dotfiles\**\install_windows.ps1" | select -F 1 | % {
    saps powershell.exe -Wait -Wo $_.DirectoryName -A "-Ex", "Bypass", "-F", $_.FullName
}
```
