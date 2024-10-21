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
These tools include the following for Windows Installs (Recommended using [Chocolatey](https://chocolatey.org/)):

- [Neovim](https://neovim.io/)
- [Neovide](https://neovide.dev/)
- [Alacritty](https://alacritty.org/)
- [PowerShell 7](https://github.com/PowerShell/PowerShell)
- [Git](https://git-scm.com/downloads)
- [Make/CMake](https://cmake.org/)
- [Unzip](https://community.chocolatey.org/packages/unzip)
- [Build Tools](https://github.com/bycloudai/InstallVSBuildToolsWindows)/[MinGW](https://www.mingw-w64.org/downloads/)
- [Rustup](https://www.rust-lang.org/tools/install)
- [Golang](https://go.dev/dl/)
- [NodeJS](https://nodejs.org/en)
- [Dotnet](https://dotnet.microsoft.com/en-us/)
- [Python](https://www.python.org/)
- [Composer](https://getcomposer.org/)

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
