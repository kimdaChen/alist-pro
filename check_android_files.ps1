# 检查 GitHub 上的 android 目录
Write-Output "=== Checking android/ directory on GitHub ==="

try {
    $android = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/contents/android" -Headers @{"Accept"="application/vnd.github.v3+json"}
    Write-Output "`nAndroid directory files:"
    $android | ForEach-Object {
        Write-Output "[$($_.type)] $($_.name)"
    }

    # 检查关键的 Gradle 文件
    Write-Output "`n=== Checking build.gradle files ==="
    $appGradle = $android | Where-Object { $_.name -eq "build.gradle" -or $_.name -eq "build.gradle.kts" }
    if ($appGradle) {
        Write-Output "Root build.gradle FOUND"
    } else {
        Write-Output "Root build.gradle NOT FOUND!"
    }

    $appDir = $android | Where-Object { $_.name -eq "app" }
    if ($appDir) {
        Write-Output "app/ directory FOUND"
        try {
            $appContents = Invoke-RestMethod -Uri $appDir.url -Headers @{"Accept"="application/vnd.github.v3+json"}
            $appBuildGradle = $appContents | Where-Object { $_.name -like "build.gradle*" }
            if ($appBuildGradle) {
                Write-Output "app/build.gradle FOUND"
            } else {
                Write-Output "app/build.gradle NOT FOUND!"
            }
        } catch {
            Write-Output "Error checking app directory: $_"
        }
    }

    # 检查 settings.gradle
    Write-Output "`n=== Checking settings.gradle ==="
    $settings = $android | Where-Object { $_.name -eq "settings.gradle" -or $_.name -eq "settings.gradle.kts" }
    if ($settings) {
        Write-Output "settings.gradle FOUND"
    } else {
        Write-Output "settings.gradle NOT FOUND!"
    }

} catch {
    Write-Output "Error: $_"
}
