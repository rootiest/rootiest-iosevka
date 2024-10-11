
param (
    [switch]$Minimal  # Add the -Minimal switch to control minimal installation
)

# Get the directory where the script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Set the font source locations (relative to the script location)
$FontFolder = Join-Path $scriptDir "TTF"
$NerdFontFolder = Join-Path $scriptDir "NerdFont"

# Check if the font folders exist
if (-Not (Test-Path $FontFolder)) {
    Write-Host "Font folder not found!" -ForegroundColor Red
    exit
}

if (-Not (Test-Path $NerdFontFolder)) {
    Write-Host "Nerd Font folder not found!" -ForegroundColor Red
    exit
}

# If the -Minimal flag is provided, install only the specified minimal fonts
if ($Minimal) {
    $MinimalFonts = @(
        "IosevkaRootiestV2-Regular.ttf",
        "IosevkaRootiestV2-Italic.ttf",
        "IosevkaRootiestV2-Oblique.ttf",
        "IosevkaRootiestV2-ObliqueItalic.ttf"
    )

    # Install minimal fonts from the TTF folder
    foreach ($fontFile in $MinimalFonts) {
        $fontPath = Join-Path $FontFolder $fontFile
        if (Test-Path $fontPath) {
            Write-Host "Installing font -" $fontFile
            Copy-Item $fontPath "C:\Windows\Fonts"
            New-ItemProperty -Name (Get-Item $fontPath).BaseName `
                -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
                -PropertyType string -Value $fontFile
        } else {
            Write-Host "Font not found: $fontFile" -ForegroundColor Red
        }
    }

    # Install the nerd font from the NerdFont folder
    $nerdFontFile = "IosevkaRootiestV2NerdFont-Regular.ttf"
    $nerdFontPath = Join-Path $NerdFontFolder $nerdFontFile
    if (Test-Path $nerdFontPath) {
        Write-Host "Installing Nerd Font -" $nerdFontFile
        Copy-Item $nerdFontPath "C:\Windows\Fonts"
        New-ItemProperty -Name (Get-Item $nerdFontPath).BaseName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
            -PropertyType string -Value $nerdFontFile
    } else {
        Write-Host "Nerd Font not found: $nerdFontFile" -ForegroundColor Red
    }
} else {
    # Full installation: List all .fon, .otf, .ttc, and .ttf files from TTF folder
    $FontList = Get-ChildItem -Path "$FontFolder\*" `
        -Include ('*.fon', '*.otf', '*.ttc', '*.ttf') -Recurse

    foreach ($Font in $FontList) {
        Write-Host "Installing font -" $Font.BaseName
        Copy-Item $Font "C:\Windows\Fonts"

        # Register font for all users
        New-ItemProperty -Name $Font.BaseName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
            -PropertyType string -Value $Font.Name
    }

    # Install all fonts from the NerdFont folder
    $NerdFontList = Get-ChildItem -Path "$NerdFontFolder\*" `
        -Include ('*.fon', '*.otf', '*.ttc', '*.ttf') -Recurse

    foreach ($NerdFont in $NerdFontList) {
        Write-Host "Installing Nerd Font -" $NerdFont.BaseName
        Copy-Item $NerdFont "C:\Windows\Fonts"

        # Register nerd font for all users
        New-ItemProperty -Name $NerdFont.BaseName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
            -PropertyType string -Value $NerdFont.Name
    }
}

