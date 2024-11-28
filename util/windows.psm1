# Function to determine if the current directory is the dotfiles repository
function IsGitRepository
{
    param (
        [string]$dir,
        [string]$url
    )

    try
    {
        $isRepo = git -C $dir rev-parse --is-inside-work-tree 2>$null
        $originUrl = git -C $dir remote get-url origin 2>$null
        return $isRepo -eq 'true' -and $originUrl -eq $url
    } catch
    {
        return $false
    }
}

function ReadyDotfilesRepo
{
    param (
        [string]$cwd,
        [string]$url,
        [Parameter(Mandatory=$false)][string]$destination
    )

    # Clone dotfiles repository to TMP if not already inside it; otherwise pull changes
    if (IsGitRepository -dir $cwd -url $url)
    {
        Write-Host "Already inside the dotfiles repository. Skipping clone step and pulling..." -ForegroundColor Yellow
        Write-Host "$(git pull)"
        return $cwd
    }

    # Mandatory parameter missing
    if (-not $PSBoundParameters.ContainsKey('destination'))
    {
        throw "Missing mandatory parameter for Repo location."
    }

    # Clone new repo in destination dir if not exists
    if ((Test-Path $destination) -and (IsGitRepository -dir $destination -url $url))
    {
        Write-Host "Pulling latest changes from dotfiles repository..." -ForegroundColor Cyan
        Write-Host "$(git -C $destination pull)"
        return $destination
    }

    Write-Host "Cloning dotfiles repository..." -ForegroundColor Cyan
    git clone $url $destination
    return $destination
}

# Function to copy files with overwrite prompt
function CopyFileWithPrompt
{
    param (
        [string]$source,
        [string]$destination
    )

    if (Test-Path $destination)
    {
        $overwrite = Read-Host "File $destination exists. Overwrite? (y/n)"
        if ($overwrite -ne 'y')
        {
            Write-Host "Skipping $destination" -ForegroundColor Yellow
            return
        }
    }
    Copy-Item -Path $source -Destination $destination -Force
}

# Function to handle URL files: download files or clone repositories
function ProcessUrlFiles
{
    param (
        [string]$source,
        [Parameter(Mandatory=$false)][string]$destination,
        [Parameter(Mandatory=$false)][string]$fileExt,
        [bool]$progress=$true
    )

    # Disable progressbar for faster download
    $progressPreference = 'continue'
    if (-not $progress)
    { $progressPreference = 'silentlyContinue'
    }

    # Ensure the destination directory exists
    if ($destination -and (-not (Test-Path $destination)))
    {
        Write-Host "Creating destination directory $destination..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Create temporary directory for curl
    $appname = Get-ChildItem $source | `
            Select-Object -ExpandProperty Directory | `
            Select-Object -ExpandProperty Name
    $tmpApp = "$env:TMP\$appname-config"
    if (-not (Test-Path $tmpApp))
    { New-Item -ItemType Directory -Path $tmpApp | Out-Null
    }
    Push-Location
    Set-Location $tmpApp

    # Find all .url files in the source directory
    $urlFiles = Get-ChildItem -Path $source -Filter '*.url'

    foreach ($file in $urlFiles)
    {
        $url = Get-Content $file.FullName
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $destinationPath = "$destination\$fileName"

        if (-not ($url -match 'git@|https://.*\.git'))
        {
            # Otherwise, download the file
            $extension = [System.IO.Path]::GetExtension($url)
            # Force apply $fileExt if given
            if ($fileExt)
            {
                $extension = $fileExt
                $url += $fileExt
            }
            $destinationPath = "$destination\$fileName$extension"

            # Respond only if destination is provided
            $conditional = " to $destinationPath"
            if (-not $destination)
            { $conditional = ''
            }

            Write-Host "Downloading $fileName from $url$conditional..." -ForegroundColor Cyan
            Invoke-WebRequest $url -OutFile $fileName$extension
            $tmpDestination = "$tmpApp\$fileName$extension"

            # Copy only if destination is provided
            if ($destination)
            { CopyFileWithPrompt $tmpDestination $destinationPath
            }
            continue
        }

        # Use $tmpApp as destination in case of git repo
        if (-not $destination)
        { $destinationPath = "$tmpApp\$fileName"
        }

        # If the URL is a git repository, pull it
        if (IsGitRepository -dir $destinationPath -url $url)
        {
            Write-Host "Pulling inside existing repository $fileName..." -ForegroundColor Cyan
            git -C $destinationPath pull
            continue
        }
        # Or otherwise clone it
        Write-Host "Cloning $fileName from $url to $destinationPath..." -ForegroundColor Cyan
        git clone $url $destinationPath
    }
    Pop-Location
}

# Function to unzip and install nerd fonts
function InstallNerdFont
{
    param (
        [string]$source
    )

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($source)
    $parent = $source -split '\\' | Select-Object -SkipLast 1 | Join-String -Separator '\'
    $destination = "$parent\$fileName"

    # Create destination directory
    if (-not (Test-Path $destination))
    { New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Extract contents of zip archive
    Write-Host "Extracting archive $source to $destination..." -ForegroundColor Cyan
    Expand-Archive $source -DestinationPath $destination | Out-Null

    # Install extracted fonts
    $fontFiles = Get-ChildItem -Path $destination -Include "*.ttf", "*.otf"

    foreach ($font in $fontFiles)
    {
        InstallFont $font
    }
}

# Reference: https://www.alkanesolutions.co.uk/2021/12/06/installing-fonts-with-powershell/
function InstallFont
{
    param
    (
        [System.IO.FileInfo]$file
    )

    # Prerequisites / Constants
    Add-Type -AssemblyName PresentationCore
    $destination = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\"
    $regKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    # Get Glyph
    $glyph = New-Object -TypeName Windows.Media.GlyphTypeface -ArgumentList $file.FullName

    $family = $glyph.Win32FamilyNames['en-us']
    if ($null -eq $family)
    { $family = $glyph.Win32FamilyNames.Values | Select-Object -First 1
    }

    $face = $glyph.Win32FaceNames['en-us']
    if ($null -eq $face)
    { $face = $glyph.Win32FaceNames.Values | Select-Object -First 1
    }

    $name = ("$family $face").Trim()
    switch ($file.Extension)
    {
        ".ttf"
        { $name = "$name (TrueType)"
        }
        ".otf"
        { $name = "$name (OpenType)"
        }
    }

    $destFileName = Join-Path -Path $destination -ChildPath $file.Name
    Write-Host "Installing font: $file with font name '$name'"
    If (-not (Test-Path $destFileName))
    { Copy-Item -Path $file.FullName -Destination $destFileName -Force
    }

    Write-Host "Registering font: $file with font name '$name'"
    $keyValue = Get-ItemProperty -Name $name -Path $regKey -ErrorAction SilentlyContinue
    If (-not $keyValue)
    {
        New-ItemProperty -Name $name -Path $regKey `
            -PropertyType string -Value $file.Name `
            -Force -ErrorAction SilentlyContinue | Out-Null
    }
}
