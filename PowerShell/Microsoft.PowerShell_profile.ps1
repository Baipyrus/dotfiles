# Function to toggle alacritty theme imports based on current theme
function ToggleThemeLines
{
    param (
        [ValidateSet("Light", "Dark")]$theme,
        [string[]]$content,
        [int]$darkLN,
        [int]$lightLN
    )

    # Read the actual lines
    $darkThemeLine = $content[$darkLN - 1]
    $lightThemeLine = $content[$lightLN - 1]

    # Determine if lines are currently commented
    $darkThemeIsCommented = $darkThemeLine -match '^\s*#'
    $lightThemeIsCommented = $lightThemeLine -match '^\s*#'

    switch ($theme)
    {
        "Light"
        {
            if (-not $darkThemeIsCommented)
            { $content[$darkLN - 1] = "# $darkThemeLine" 
            }
            if ($lightThemeIsCommented)
            { $content[$lightLN - 1] = $lightThemeLine -replace '^\s*#\s?', '' 
            }
        }
        "Dark"
        {
            if ($darkThemeIsCommented)
            { $content[$darkLN - 1] = $darkThemeLine -replace '^\s*#\s?', '' 
            }
            if (-not $lightThemeIsCommented)
            { $content[$lightLN - 1] = "# $lightThemeLine" 
            }
        }
    }

    return $content
}

# Get theme personalization settings
$settings = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'

# Read the content of the Alacritty config file
$alacritty = "$env:APPDATA\alacritty\alacritty.toml"
$content = Get-Content -Path $alacritty

# Determine current theme
$theme = if ($settings.AppsUseLightTheme)
{ "Light" 
} else
{ "Dark" 
}

# Toggle the theme lines based on the current theme
ToggleThemeLines -theme $theme -content $content -darkLN 2 -lightLN 3 | Set-Content -Path $alacritty
