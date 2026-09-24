# Builds the plugin in a throwaway Cordova app against cordova-android 11 (AGP 7.4 / Gradle 7.6).
# Full cordova-android 13 belongs to the app upgrade (fase 5), not this plugin check.
$ErrorActionPreference = 'Stop'

$pluginRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$harnessDir = Join-Path $PSScriptRoot 'agp-harness'

$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
$env:ANDROID_HOME = 'C:\Users\Stefan\AppData\Local\Android\Sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:PATH = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\cmdline-tools\latest\bin;$env:PATH"

Write-Host "JAVA_HOME=$env:JAVA_HOME"
& "$env:JAVA_HOME\bin\java.exe" -version

if (Test-Path (Join-Path $harnessDir 'config.xml')) {
    Write-Host "Reusing harness at $harnessDir"
} else {
    if (Test-Path $harnessDir) {
        Remove-Item $harnessDir -Recurse -Force
    }
    Write-Host "Creating harness at $harnessDir"
    npx --yes cordova create $harnessDir com.ecologium.scannerharness ScannerHarness
}

Set-Location $harnessDir

if (-not (Test-Path (Join-Path $harnessDir 'platforms\android'))) {
    npx --yes cordova platform add android@11.0.0 --save
}

try {
    npx --yes cordova plugin remove cordova-plugin-barcodescanner-binary-qr --nosave
} catch {
    Write-Host "Plugin was not installed yet; continuing."
}
npx --yes cordova plugin add $pluginRoot --nofetch --force

npx --yes cordova build android
