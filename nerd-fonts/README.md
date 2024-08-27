# Nerd Fonts Configuration

This directory contains my [Nerd Fonts](https://www.nerdfonts.com/) configuration
and any related resources.

## Files

- **CascadiaCode.url**: This file contains the URL to the `Cascadia Code` Nerd Font patch.
- **CascadiaMono.url**: This file contains the URL to the `Cascadia Mono` Nerd Font patch.

## Installation

To use this configuration:

1. Clone the repository.
2. Download all required fonts from files:

    ```pwsh
    curl -LO "$(Get-Content ./nerd-fonts/CascadiaMono.url).zip"
    ```

3. Unpack and install all downloaded fonts to your system's font storage.
