# Alacritty Configuration

This directory contains my Alacritty terminal emulator configuration.

## Files

- **alacritty.yml**: This is the main configuration file for Alacritty, containing
settings for colors, fonts, keybindings, and more.
- **catppuccin-mocha**: This file contains the URL to the `catppuccin-mocha` theme
for Alacritty.
- **catppuccin-latte**: This file contains the URL to the `catppuccin-latte` theme
for Alacritty.

## Installation

To use this configuration:

1. Clone the repository.
2. Download all required themes from files:

    ```pwsh
    curl -LO "${Get-Content ./alacritty/catpuccin-mocha}"
    ```

3. Copy the `alacritty.yml` file and all downloaded themes to your Alacritty
configuration directory.
