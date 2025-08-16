param(
    [string]$Version = "1.0.0"
)

$nugetConfigPath = "nuget.local.json"
if (!(Test-Path $nugetConfigPath)) {
    Write-Error "nuget.local.json file not found. Please create it with your NuGet API key."
    exit 1
}

try {
    $nugetConfig = Get-Content $nugetConfigPath | ConvertFrom-Json
} catch {
    Write-Error "Failed to parse nuget.local.json. Ensure it is valid JSON."
    exit 1
}

if (-not $nugetConfig.ApiKey) {
    Write-Error "ApiKey property not found in nuget.local.json."
    exit 1
}

$ApiKey = $nugetConfig.ApiKey
$projectPath = "..\src\Controls\Avalonia.Controls.IconsHero.csproj"
$Source = "https://api.nuget.org/v3/index.json"

Write-Host "Building Avalonia.Controls.IconsHero..."
dotnet build $projectPath -c Release

Write-Host "Packing NuGet package..."
dotnet pack $projectPath -c Release -p:PackageVersion=$Version --output "..\src\Controls\bin\Release"

$packageFile = Get-ChildItem "..\src\Controls\bin\Release" -Filter "Avalonia.Controls.IconsHero.*.nupkg" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $packageFile) {
    Write-Error "NuGet package not found. Packing may have failed."
    exit 1
}

Write-Host "Pushing package $($packageFile.Name) to NuGet..."
dotnet nuget push $packageFile.FullName --api-key $ApiKey --source $Source

Write-Host "NuGet publish complete."
