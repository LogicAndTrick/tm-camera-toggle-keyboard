
$pluginName = "CameraToggle-Keyboard";

$srcDir = Join-Path $PSScriptRoot "src"
$srcPath = Join-Path $srcDir "*"
$tomlPath = Join-Path $PSScriptRoot "info.toml"
$srcFiles = @($srcPath, $tomlPath)

$pluginDir = Join-Path $env:USERPROFILE "OpenplanetNext\Plugins"
$targetFile  = Join-Path $pluginDir "$pluginName.op"

Write-Host "Building: $pluginName..." -ForegroundColor Green
Write-Host "Source: $srcFiles" -ForegroundColor Cyan
Write-Host "Target: $targetFile" -ForegroundColor Cyan

Compress-Archive -Path $srcFiles -DestinationPath "$targetFile.zip" -Force

if (Test-Path $targetFile) {
    Write-Host "File exists, deleting it first..." -ForegroundColor Cyan
    Remove-Item $targetFile
}

Move-Item "$targetFile.zip" $targetFile

Write-Host "Done." -ForegroundColor Green
