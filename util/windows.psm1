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
        git pull
        return $cwd
    }

    # Mandatory parameter missing
    if (-not $PSBoundParameters.ContainsKey('destination'))
    {
        throw "Missing mandatory parameter for Repo location."
    }

    # Clone new repo in destination dir if not exists
    if (-not (Test-Path $destination))
    {
        Write-Host "Cloning dotfiles repository..." -ForegroundColor Cyan
        git clone $url $destination
        return $destination
    }

    Write-Host "Pulling latest changes from dotfiles repository..." -ForegroundColor Cyan
    git -C $destination pull
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
        [Parameter(Mandatory=$false)][string]$fileExt
    )

    # Ensure the destination directory exists
    if ($destination -and (-not (Test-Path $destination)))
    {
        Write-Host "Creating destination directory $destination..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Create temporary directory for curl
    $appname = $source.Split('\')[-1]
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
            Invoke-RestMethod $url -OutFile $fileName$extension
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

# Function to expand zip archives and copy to destination paths
function UnzipAndInstall
{
    param (
        [string]$source
    )

    # Create temporary directory for unzip
    $appname = $source.Split('\')[-1]
    $tmpApp = "$env:TMP\$appname-config"
    if (-not (Test-Path $tmpApp))
    { New-Item -ItemType Directory -Path $tmpApp | Out-Null
    }

    $destination = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\"
    if (-not (Test-Path $destination))
    { New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Find all .url files in the source directory
    $urlFiles = Get-ChildItem -Path $source -Filter '*.url'

    foreach ($file in $urlFiles)
    {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        Write-Host "Extracting archive $tmpApp\$fileName.zip to $tmpApp\$fileName\..." -ForegroundColor Cyan
        Expand-Archive "$tmpApp\$fileName.zip" -DestinationPath "$tmpApp\$fileName" | Out-Null

        Write-Host "Installing fonts from $tmpApp\$fileName\ for current user..." -ForegroundColor Cyan
        Copy-Item -Path "$tmpApp\$fileName\*" -Destination $destination -Force -ErrorAction SilentlyContinue
    }
}
