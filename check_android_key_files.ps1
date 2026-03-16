# 检查已下载的关键 Android 文件
Write-Output "=== Checking Android Key Files ===`n"

$files = @(
    "android/build.gradle",
    "android/settings.gradle",
    "android/gradle.properties",
    "android/gradle/wrapper/gradle-wrapper.properties",
    "android/app/build.gradle"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Output "[OK] $file"
    } else {
        Write-Output "[MISSING] $file"
    }
}

Write-Output "`n=== Reading build.gradle (root) ==="
if (Test-Path "android/build.gradle") {
    Get-Content "android/build.gradle"
}

Write-Output "`n=== Reading settings.gradle ==="
if (Test-Path "android/settings.gradle") {
    Get-Content "android/settings.gradle"
}

Write-Output "`n=== Reading app/build.gradle ==="
if (Test-Path "android/app/build.gradle") {
    Get-Content "android/app/build.gradle"
}
