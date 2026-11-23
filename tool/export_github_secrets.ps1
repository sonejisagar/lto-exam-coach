# Export GitHub Secrets Helper Script for LTO Exam Coach Philippines
$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " GitHub Actions Secrets for LTO Exam Coach               " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Add these Repository Secrets at:" -ForegroundColor Yellow
Write-Host "https://github.com/sonejisagar/lto-exam-coach/settings/secrets/actions" -ForegroundColor Green
Write-Host ""

# 1. Keystore Base64
$keystorePath = "android/app/upload-keystore.jks"
if (Test-Path $keystorePath) {
    $keystoreBytes = [System.IO.File]::ReadAllBytes((Resolve-Path $keystorePath).Path)
    $keystoreBase64 = [System.Convert]::ToBase64String($keystoreBytes)
    [System.IO.File]::WriteAllText((Join-Path (Get-Location) "tool/keystore_base64.txt"), $keystoreBase64, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[1] Secret Name: KEYSTORE_BASE64" -ForegroundColor White
    Write-Host "    Saved to tool/keystore_base64.txt (Length: $($keystoreBase64.Length) chars)" -ForegroundColor Gray
} else {
    Write-Host "[!] Keystore file not found at $keystorePath" -ForegroundColor Red
}

# 2-4. Read signing properties locally from android/key.properties
$keyPropsPath = "android/key.properties"
if (Test-Path $keyPropsPath) {
    $props = @{}
    Get-Content $keyPropsPath | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            $props[$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    Write-Host ""
    Write-Host "[2] Secret Name: KEY_ALIAS" -ForegroundColor White
    Write-Host "    Value: $($props['keyAlias'])" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[3] Secret Name: KEY_PASSWORD" -ForegroundColor White
    Write-Host "    Value: $($props['keyPassword'])" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[4] Secret Name: STORE_PASSWORD" -ForegroundColor White
    Write-Host "    Value: $($props['storePassword'])" -ForegroundColor Gray
} else {
    Write-Host "[!] android/key.properties not found locally" -ForegroundColor Red
}

# 5. google-services.json Base64
$googleServicesPath = "android/app/google-services.json"
if (Test-Path $googleServicesPath) {
    $gsBytes = [System.IO.File]::ReadAllBytes((Resolve-Path $googleServicesPath).Path)
    $gsBase64 = [System.Convert]::ToBase64String($gsBytes)
    [System.IO.File]::WriteAllText((Join-Path (Get-Location) "tool/google_services_base64.txt"), $gsBase64, [System.Text.UTF8Encoding]::new($false))
    Write-Host ""
    Write-Host "[5] Secret Name: GOOGLE_SERVICES_JSON_BASE64" -ForegroundColor White
    Write-Host "    Saved to tool/google_services_base64.txt (Length: $($gsBase64.Length) chars)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[6] Secret Name: PLAY_STORE_JSON_KEY" -ForegroundColor White
Write-Host "    Value: Paste the contents of your Google Cloud / Play Console Service Account JSON file here." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
