Import-Module ./util/windows.psm1
Import-Module ./util/winget.psm1


# (Optionally) Install required Software
InstallWinget

# Define paths for tools and configurations
$dotfilesRepo = "$env:TMP\dotfiles"
$alacrittyConfigDir = "$env:APPDATA\alacritty"
$psProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$repoUrl = "https://github.com/Baipyrus/dotfiles.git"

# Check if the script is running inside the dotfiles repository
$currentDir = (Get-Location).Path


ReadyDotfilesRepo -cwd $currentDir -url $repoUrl -destination $dotfilesRepo

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
{
    # TODO: Expand into generic WSL setup while installing required dev tools
    ProcessUrlFiles -sourceDir "$dotfilesRepo\nvim"
    Set-Location "$env:TMP\nvim-config"
    Write-Host "Copying (forcably) configuration to WSL..." -ForegroundColor Yellow
    wsl.exe cp -rf . ~/.config/ 2>$null | Out-Null
    Set-Location -
}

# Setting up PowerShell Profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Cyan
CopyFileWithPrompt "$dotfilesRepo\PowerShell\Microsoft.PowerShell_profile.ps1" $psProfile

# Setting up self-made ProxySwitcher
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host "Setting up ProxySwitcher via subscript..." -ForegroundColor Cyan
Invoke-RestMethod 'https://raw.githubusercontent.com/Baipyrus/ProxySwitcher/main/install.ps1' | Invoke-Expression
Write-Host "============================================" -ForegroundColor DarkGray

# Installing Nerd Fonts
Write-Host "Installing Nerd Fonts..." -ForegroundColor Cyan
ProcessUrlFiles -source "$dotfilesRepo\nerd-fonts" -fileExt ".zip"
UnzipAndInstall -source "$dotfilesRepo\nerd-fonts"

# Final message
Write-Host "Windows setup complete!" -ForegroundColor Green
