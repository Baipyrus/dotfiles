# Define paths for tools and configurations
$dotfilesRepo = "$env:TMP\dotfiles"
$alacrittyConfigDir = "$env:APPDATA\alacritty"
$psProfile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$repoUrl = "https://github.com/Baipyrus/dotfiles.git"

# Function to determine if the current directory is the dotfiles repository
function IsInDotfilesRepo
{
    param ([string]$currentDir)

    try
    {
        $isRepo = git -C $currentDir rev-parse --is-inside-work-tree 2>$null
        $originUrl = git -C $currentDir remote get-url origin 2>$null
        return $isRepo -eq 'true' -and $originUrl -eq $repoUrl
    } catch
    {
        return $false
    }
}

# Check if the script is running inside the dotfiles repository
$currentDir = (Get-Location).Path

if (IsInDotfilesRepo -currentDir $currentDir)
{
    Write-Host "Already inside the dotfiles repository. Skipping clone step and pulling..." -ForegroundColor Yellow
    $dotfilesRepo = $currentDir
    git -C $dotfilesRepo pull
} else
{
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
}
}
