function InstallWSL
{
    Write-Host "Enabling and downloading required Windows Features..."
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart | Out-Null
    Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart | Out-Null
    Write-Host "Installing WSL2..."
    wsl.exe --install --no-distribution
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

    $update = Read-Host "Install/Update WSL2 now? [Y/n]"
    if ($update.ToLower() -ne 'n')
    {
        # Start admin process, import this script, run 'InstallPackages' function
        Start-Process powershell.exe -Verb RunAs -Wait `
            -ArgumentList "-ExecutionPolicy", "Bypass", `
            "-C", "cd $pwd; ipmo ./util/wsl.psm1; InstallWSL"
    }

    $install = Read-Host "Install WSL Distribution now? [Y/n]"
    if ($install.ToLower() -eq 'n')
    { return
    }

    wsl.exe --install -d Ubuntu

    # Add newly created user to sudoers group
    $user = wsl.exe cut "-d:" "-f1" /etc/passwd | Select-Object -Last 1
    wsl.exe -u root echo "$user ALL=(ALL) NOPASSWD:ALL" ">>" "/etc/sudoers.d/$user"

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

    Push-Location
    ProcessUrlFiles -source $source
    Set-Location "$env:TMP\nvim-config"

    Write-Host "Copying (forcably) configuration to WSL..." -ForegroundColor Yellow
    wsl.exe cp -rf . ~/.config/ 2>$null | Out-Null
    Pop-Location
}
