function InstallWinget
{
    $download = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
    $setup = "$env:TMP\winget_setup.msixbundle"

    if (-not (Test-Path $setup))
    {
        $releases = Invoke-RestMethod $download
        $assets = $releases | Select-Object -ExpandProperty "assets"
        $installer = $assets | Where-Object "name" -Match "msixbundle"
        $url = $installer | Select-Object -ExpandProperty "browser_download_url"
        Invoke-RestMethod $url -OutFile $setup
    }

    Add-AppxPackage -Path $setup
}

function WingetInstall
{
    $update = Read-Host "Install/Update WinGet now? [Y/n]"
    if ($update.ToLower() -ne 'n')
    {
        # Start admin process, import this script, run 'InstallPackages' function
        Start-Process powershell.exe -Verb RunAs -Wait `
            -ArgumentList "-ExecutionPolicy", "Bypass", `
            "-C", "cd $pwd; ipmo ./util/winget.psm1; InstallWinget"
    }

    $install = Read-Host "Install WinGet Packages now? [Y/n]"
    if ($install.ToLower() -eq 'n')
    { return
    }

    winget.exe install -s winget --accept-source-agreements (Get-Content ./util/winget.list)
}
