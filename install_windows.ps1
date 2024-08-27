# Define paths for tools and configurations
$dotfilesRepo = "$env:TMP\dotfiles"
$alacrittyConfigDir = "$env:APPDATA\alacritty"
$psProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$repoUrl = "https://github.com/Baipyrus/dotfiles.git"

# Clone dotfiles repository to TMP if not already inside it
if (-not (Test-Path $dotfilesRepo))
{
    Write-Host "Cloning dotfiles repository..." -ForegroundColor Cyan
    git clone $repoUrl $dotfilesRepo
} else
{
    Write-Host "Pulling latest changes from dotfiles repository..." -ForegroundColor Cyan
    git -C $dotfilesRepo pull
}
