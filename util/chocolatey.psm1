function InstallPackages
{
    choco.exe install (Get-Content ./util/chocolatey.list)
}

function ChocolateyInstall
{
    $install = Read-Host "Install Chocolatey Packages now? [Y/n]"
    if ($install.ToLower() -eq 'n')
    { return
    }

    # Start admin process, import this script, run 'InstallPackages' function
    Start-Process powershell.exe -Verb RunAs -Wait `
        -ArgumentList "-C", "'Import-Module ./chocolatey.psm1; InstallPackages'"
}
