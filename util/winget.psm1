function InstallWinget
{
    # Reference: https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox
    $progressPreference = 'silentlyContinue'
    Write-Host "Installing WinGet PowerShell module from PSGallery..."
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
    Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
    Repair-WinGetPackageManager
}

function WingetInstall
{
    $install = Read-Host "Install/Update WinGet now? [Y/n]"
    if ($install.ToLower() -ne 'n')
    {
        # Start admin process, import this script, run 'InstallPackages' function
        Start-Process powershell.exe -Verb RunAs -Wait `
            -ArgumentList "-ExecutionPolicy", "Bypass", `
            "-C", "'Import-Module ./util/winget.psm1; InstallWinget'"
    }

    winget.exe install -s winget --accept-source-agreements (Get-Content ./util/winget.list)
}
