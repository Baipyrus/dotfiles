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

<details><summary>Windows Subsystem for Linux</summary>

```bash
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt install make gcc ripgrep unzip git xclip neovim nodejs python3-venv
curl https://sh.rustup.rs -sSf | sh
curl -LO https://go.dev/dl/go1.23.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

</details>

<details><summary>Winget and Chocolatey</summary>

```pwsh
winget install chocolatey.chocolatey Neovide.Neovide Alacritty.Alacritty Git.Git GoLang.Go Microsoft.DotNet.SDK.8 OpenJS.NodeJS.LTS Python.Python.3.12 Rustlang.Rustup
choco install neovim ripgrep curl wget fd unzip gzip mingw make
```

</details>

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
