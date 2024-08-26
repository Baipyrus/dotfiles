# Alacritty Configuration

This directory contains my configuration for the [Alacritty terminal emulator](https://alacritty.org/).
Any other files contain references to themes to be used inside of Alacritty like
`mocha` or `latte` from [`catppuccin`](https://github.com/catppuccin/alacritty).

## Files

- **alacritty.yml**: This is the main configuration file for Alacritty, containing
settings for shell, fonts, keybindings, and more.
- **catppuccin-mocha**: This file contains the URL to the `catppuccin-mocha` theme
for Alacritty.
- **catppuccin-latte**: This file contains the URL to the `catppuccin-latte` theme
for Alacritty.

## Installation

To use this configuration:

1. Clone the repository.
2. Download all required themes from files:

    ```pwsh
    curl -LO "$(Get-Content ./alacritty/catpuccin-mocha)"
    ```

3. Copy the `alacritty.yml` file and all downloaded themes to your Alacritty
configuration directory.
