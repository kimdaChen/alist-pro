# 对比 GitHub 仓库和本地文件
Write-Output "=== Comparing Files ===`n"

# 1. 检查 pubspec.yaml
Write-Output "=== GitHub pubspec.yaml ==="
$pubspec = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/contents/pubspec.yaml" -Headers @{"Accept"="application/vnd.github.v3+json"}
$content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($pubspec.content))
Write-Output $content

Write-Output "`n=== Local pubspec.yaml (first 50 lines) ==="
$localPubspec = Get-Content "pubspec.yaml" -Raw
$localPubspec -split "`n" | Select-Object -First 50 | ForEach-Object { Write-Output $_ }

# 2. 检查 build-apk.yml
Write-Output "`n=== GitHub build-apk.yml ==="
$workflow = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/contents/.github/workflows/build-apk.yml" -Headers @{"Accept"="application/vnd.github.v3+json"}
$content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($workflow.content))
Write-Output $content

Write-Output "`n=== Local build-apk.yml ==="
$localWorkflow = Get-Content ".github/workflows/build-apk.yml" -Raw
Write-Output $localWorkflow
