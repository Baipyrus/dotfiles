Import-Module ./util/chocolatey.psm1
Import-Module ./util/windows.psm1
Import-Module ./util/winget.psm1
Import-Module ./util/wsl.psm1


# (Optionally) Install required Software
WingetInstall
ChocolateyInstall
WSLInstall

Write-Host "Installation Steps complete!" -ForegroundColor Cyan
$continue = Read-Host "Continue with configuration? [Y/n]"
if ($continue.ToLower() -eq 'n')
{ return
}


# Define paths for tools and configurations
$dotfilesRepo = (Get-Location).Path
$alacrittyConfigDir = "$env:APPDATA\alacritty"
$psProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


# Setting up Alacritty Configuration
Write-Host "Setting up Alacritty configuration..." -ForegroundColor Cyan
ProcessUrlFiles -source "$dotfilesRepo\alacritty" -destination $alacrittyConfigDir

# Copy the main Alacritty configuration file
CopyFileWithPrompt "$dotfilesRepo\alacritty\alacritty.toml" "$alacrittyConfigDir\alacritty.toml"

# Setting up Neovim Configuration
Write-Host "Setting up Neovim configuration..." -ForegroundColor Cyan
$ubuntu = wsl.exe -l --all | Where-Object { $_.Replace("`0", "") -match '^Ubuntu' }
if ($null -eq $ubuntu)
{ ProcessUrlFiles -source "$dotfilesRepo\nvim" -destination "$env:LOCALAPPDATA"
} else
{ InstallWSLNeovim -source "$dotfilesRepo\nvim"
}

# Setting up PowerShell Profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Cyan
# Create local PowerShell profile directory
$psDir = Split-Path -Path $psProfile
if (-not (Test-Path $psDir))
{ New-Item -ItemType Directory -Path $psDir | Out-Null
}
# Copy existing startup script to destination
CopyFileWithPrompt "$dotfilesRepo\PowerShell\Microsoft.PowerShell_profile.ps1" $psProfile

# Setting up self-made ProxySwitcher
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host "Setting up ProxySwitcher via subscript..." -ForegroundColor Cyan
Invoke-RestMethod 'https://raw.githubusercontent.com/Baipyrus/ProxySwitcher/main/install.ps1' | Invoke-Expression
Write-Host "============================================" -ForegroundColor DarkGray

# Installing Nerd Fonts
Write-Host "Installing Nerd Fonts..." -ForegroundColor Cyan
ProcessUrlFiles -source "$dotfilesRepo\nerd-fonts" -fileExt ".zip" -progress $false
Get-ChildItem -Path "$env:TMP\nerd-fonts-config" -Filter "*.zip" | `
                ForEach-Object { InstallFont -source $_.FullName }

# Final message
Write-Host "Windows setup complete!" -ForegroundColor Green
Read-Host "Press any key to continue ..."
