function InstallWSL
{
    # Reference: https://learn.microsoft.com/en-us/windows/wsl/install-manual
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl.exe --update
    wsl.exe --set-default-version 2
}

function WSLInstall
{
    # Skip if any WSL2 installations can be found
    $installations = wsl.exe -l -v
    $filtered = $installations | Where-Object { $_.Replace("`0", '') -match '^.{2}Ubuntu' }
    $versions = $filtered | ForEach-Object { $_.Substring($_.LastIndexOf(' ') + 1) }
    if ($null -ne $versions -and $versions.Contains('2'))
    { return
    }

    $install = Read-Host "Install/Update WSL2 now? [Y/n]"
    if ($install.ToLower() -ne 'n')
    {
        # Start admin process, import this script, run 'InstallPackages' function
        Start-Process powershell.exe -Verb RunAs -Wait `
            -ArgumentList "-C", "'Import-Module ./wsl.psm1; InstallWSL'"
    }
    wsl.exe --install -d Ubuntu

    # Add newly created user to sudoers group
    $user = wsl.exe cut "-d:" "-f1" /etc/passwd
    wsl.exe -u root echo "echo ""$user ALL=(ALL) NOPASSWD:ALL"" >> /etc/sudoers.d/$user"

    # Update packages and install from list
    wsl.exe sudo apt update "&&" sudo apt upgrade "-y"
    wsl.exe sudo apt install "-y" (Get-Content ./util/wsl.list)
}

function InstallWSLNeovim
{
    param (
        [string]$source
    )

    Import-Module ./windows.psm1

    ProcessUrlFiles -sourceDir $source
    Set-Location "$env:TMP\nvim-config"
    Write-Host "Copying (forcably) configuration to WSL..." -ForegroundColor Yellow
    wsl.exe cp -rf . ~/.config/ 2>$null | Out-Null
    Set-Location -
}
