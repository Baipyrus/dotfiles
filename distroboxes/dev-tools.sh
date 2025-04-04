#!/bin/bash
# Create container using:
# distrobox create -n dev-tools -p -i quay.io/fedora/fedora:41
# distrobox enter -n dev-tools

# Install Fyra Labs Terra repository
sudo dnf install -y --nogpgcheck --repofrompath \
    'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# Install programs and sdks
sudo dnf install -y $(cat util/dnf.list)

# Fetch and try installing PowerShell from GitHub
download_url="https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
rpm_url=$(curl -s $download_url | \
    jq -r '.assets[] | select(.name | test(".rh.x86_64.rpm")) | .browser_download_url')
if [[ -n "$rpm_url" ]]; then
    sudo dnf install -y "$rpm_url"
fi

# Chande directory to avoid naming overlaps
cd ./distroboxes/

# Export apps
distrobox-export -a alacritty
distrobox-export -a neovide
distrobox-export -b $(which neovide)
distrobox-export -b $(which nvim)
distrobox-export -b $(which rg)
