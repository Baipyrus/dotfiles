# Neovim Configuration

This configuration varies from this here standard. The actual Neovim configuration
can be found under a separate repository [here](https://github.com/Baipyrus/nvim-config).
These files only serve as a reference to all configurations that are to be installed
in my personal configuration.

## Files

- **nvim.url**: This file contains the URL to my personal configuration that is to be
installed as the main configuration on the machine.
- **nvim-modular.url**: This file contains the URL to the repository of [`kickstart-modular.nvim`](https://github.com/dam9000/kickstart-modular.nvim)
which is serving as a secondary configuration for debugging purposes.

## Installation

To use this configuration:

1. Clone the repository.
2. Download all required configurations from files:

    ```pwsh
    git clone "$(Get-Content ./nvim/nvim.url)" $env:LOCALAPPDATA/nvim/
    ```

3. Copy the downloaded configuration to your system's specific location:

    ```pwsh
    # Powershell - Windows Location
    Copy-Item nvim/ $env:LOCALAPPDATA/
    ```
