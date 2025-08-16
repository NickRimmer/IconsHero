# phosphor-icons
# https://github.com/phosphor-icons/web

$ErrorActionPreference = "Stop"
$tmpDir = "$env:TEMP\IconsHero"
if (Test-Path $tmpDir)
{
    Remove-Item -Path $tmpDir -Recurse -Force
}
New-Item -Path $tmpDir -ItemType Directory | Out-Null

function Get-Phosphor
{
    param (
        [string]$weight,
        [string]$codeFont
    )

    $stylesUrl = "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@latest/src/$weight/style.css"
    Write-Host "Downloading phosphor style: $stylesUrl"
    $styleContent = Invoke-RestMethod -Uri $stylesUrl

    # parse codes from styles to Name and Content code.
    $pattern = '\.ph.*\.ph-([a-z0-9\-]+):before\s*\{\s*content:\s*"\\([a-f0-9]+)";\s*\}'
    $codes = @()
    foreach ($match in [regex]::Matches($styleContent, $pattern, 'IgnoreCase'))
    {
        $name = $match.Groups[1].Value
        $code = $match.Groups[2].Value

        # Convert kebab-case to PascalCase
        $pascalName = (($name -split '-') | ForEach-Object {
            $_.Substring(0, 1).ToUpper() + $_.Substring(1)
        }) -join ''

        $weightPascal = $weight.Substring(0, 1).ToUpper() + $weight.Substring(1)
        $name = "Phosphor_$( $pascalName )_$( $weightPascal )"

        $codes += [PSCustomObject]@{
            Name = $name
            Content = $code
        }
    }

    Write-Host "Found $( ($codes | Measure-Object).Count ) icons in $weight style."
    if ($codes.Count -eq 0)
    {
        throw "No icons found in $weight style. Please check the URL: $stylesUrl and ensure the style is correct."
    }

    # search url("./Phosphor-...ttf") and extract the font file name
    $fontFileName = $styleContent -match 'url\(".+\.ttf"\)' | Out-Null
    $fontFileName = $Matches[0] -replace 'url\("(.+)"\)', '$1'
    $fontUrl = "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@latest/src/$weight/$fontFileName"
    Write-Host "Downloading phosphor font: $fontUrl"

    # download TTF font file to a temporary directory
    $fontTmpDir = "$tmpDir\Phosphor"
    if (-Not (Test-Path $fontTmpDir))
    {
        New-Item -Path $fontTmpDir -ItemType Directory | Out-Null
    }

    $fontFilePath = "$fontTmpDir\$fontFileName"
    Write-Host "Font downloading from: $fontUrl"
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontFilePath

    return [PsCustomObject]@{
        Codes = $codes
        Font = $codeFont
        FontFilePath = $fontFilePath
    }
}

function Get-Fluent
{
    param (
        [string]$weight,
        [string]$codeFont
    )

    $weightPascal = $weight.Substring(0, 1).ToUpper() + $weight.Substring(1)
    $stylesUrl = "https://raw.githubusercontent.com/microsoft/fluentui-system-icons/refs/heads/main/fonts/FluentSystemIcons-$weightPascal.css"
    Write-Host "Downloading Fluent UI style: $stylesUrl"
    $styleContent = Invoke-RestMethod -Uri $stylesUrl

    # parse codes from styles to Name and Content code.
    $pattern = '\.icon-ic_fluent_([a-z0-9\-_]+)_24_.+:before\s*\{\s*content:\s*"\\([a-f0-9]+)";\s*\}'

    $codes = @()
    foreach ($match in [regex]::Matches($styleContent, $pattern, 'IgnoreCase'))
    {
        $name = $match.Groups[1].Value
        $code = $match.Groups[2].Value

        # Convert kebab-case to PascalCase
        $pascalName = (($name -split '_') | ForEach-Object {
            $_.Substring(0, 1).ToUpper() + $_.Substring(1)
        }) -join ''

        $name = "Fluent_$( $pascalName )_$( $weightPascal )"

        $codes += [PSCustomObject]@{
            Name = $name
            Content = $code
        }
    }

    Write-Host "Found $( ($codes | Measure-Object).Count ) icons in $weight style."
    if ($codes.Count -eq 0)
    {
        throw "No icons found in $weight style. Please check the URL: $stylesUrl and ensure the style is correct."
    }

    # search 'url("./FluentSystemIcons-Regular.ttf' and extract the font file name
    $fontFileName = $styleContent -match 'url\(".+\.ttf' | Out-Null
    $fontFileName = $Matches[0] -replace 'url\("([^?"])', '$1'
    $fontUrl = "https://raw.githubusercontent.com/microsoft/fluentui-system-icons/refs/heads/main/fonts/$fontFileName"
    Write-Host "Downloading Fluent UI font: $fontUrl"

    # download TTF font file to a temporary directory
    $fontTmpDir = "$tmpDir\Fluent"
    if (-Not (Test-Path $fontTmpDir))
    {
        New-Item -Path $fontTmpDir -ItemType Directory | Out-Null
    }

    $fontFilePath = "$fontTmpDir\$fontFileName"
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontFilePath
    Write-Host "Font downloaded to: $fontFilePath"

    return [PsCustomObject]@{
        Codes = $codes
        Font = $codeFont
        FontFilePath = $fontFilePath
    }
}

function Save-FontFiles
{
    param (
        [string]$path
    )

    $fontsDir = "$PSScriptRoot\..\src\Controls\Assets\fonts"
    Copy-Item -Path $path -Destination $fontsDir -Force
}

function Write-Codes
{
    param(
        [array]$icons
    )

    $codes = @()
    foreach ($icon in $icons)
    {
        foreach ($code in $icon.Codes)
        {
            $codes += [PSCustomObject]@{
                Name = $code.Name
                Content = $code.Content
                Font = $icon.Font
            }
        }
    }

    $iconsFilePath = "$PSScriptRoot\..\src\Controls\IconsHeroCode.cs.txt"
    $iconsFilePathTmp = "$PSScriptRoot\..\src\Controls\IconsHeroCode.cs"

    $originalContent = Get-Content -Path $iconsFilePath -Raw
    $pattern = '(?<=public enum IconsHeroCode\s*\{)(.*?)(?=\})'
    $enumValues = ($codes | ForEach-Object {
        "
    [Code(`"$( $_.Content )`", Font.$( $_.Font ))]
    $( $_.Name ),"
    }) -join "`n"
    $updatedContent = [regex]::Replace($originalContent, $pattern, "$( $enumValues )`n", 'Singleline').Trim()
    Set-Content -Path $iconsFilePathTmp -Value $updatedContent -Encoding UTF8
}

# load the Phosphor font
$iconsPhRegular = Get-Phosphor -weight "regular" -codeFont "PhosphorRegular"
$iconsPhFill = Get-Phosphor -weight "fill" -codeFont "PhosphorFill"
$iconsFluentRegular = Get-Fluent -weight "regular" -codeFont "FluentSystemIconsRegular"
$iconsFluentFill = Get-Fluent -weight "filled" -codeFont "FluentSystemIconsFilled"

## save fonts
Save-FontFiles -path $iconsPhRegular.FontFilePath
Save-FontFiles -path $iconsPhFill.FontFilePath
Save-FontFiles -path $iconsFluentRegular.FontFilePath
Save-FontFiles -path $iconsFluentFill.FontFilePath

# write codes
Write-Codes -icons @($iconsPhRegular, $iconsPhFill, $iconsFluentRegular, $iconsFluentFill)
