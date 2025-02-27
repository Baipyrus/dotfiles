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

# Function to copy files with overwrite prompt
function CopyFileWithPrompt
{
    param (
        [string]$source,
        [string]$destination
    )

    if (Test-Path $destination)
    {
        $overwrite = Read-Host "File $destination exists. Overwrite? (y/N)"
        if ($overwrite.ToLower() -ne 'y')
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
    $appname = Split-Path -Leaf $source
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
function InstallFont
{
    param (
        [string]$source
    )

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($source)
    $parent = Get-ChildItem $source | `
            Select-Object -ExpandProperty Directory | `
            Select-Object -ExpandProperty FullName
    $destination = "$parent\$fileName"

    # Create destination directory
    if (-not (Test-Path $destination))
    { New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Extract contents of zip archive
    Write-Host "Extracting archive $source to $destination..." -ForegroundColor Cyan
    Expand-Archive $source -DestinationPath $destination -Force | Out-Null

    # Install extracted fonts
    $fontFiles = Get-ChildItem -Path $destination -Recurse -Include "*.ttf", "*.otf"

    # Apparently 'hard coded' installation using a 'Shell Application Object'
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in $fontFiles)
    {
        $fonts.CopyHere(
            $file.FullName,
            0x14
        )
    }
}
