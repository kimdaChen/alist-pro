# 从原始仓库 xlist-io/xlist 下载 android 目录
$baseDir = "C:\Users\chenj\WorkBuddy\Claw"

# 递归下载目录函数
function DownloadDirectory($sourceUrl, $targetPath) {
    Write-Output "  Downloading directory: $targetPath"
    $contents = Invoke-RestMethod -Uri $sourceUrl -Headers @{"Accept"="application/vnd.github.v3+json"}

    if (-not (Test-Path $targetPath)) {
        New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
    }

    foreach ($item in $contents) {
        $itemPath = Join-Path $targetPath $item.name
        if ($item.type -eq "file") {
            Write-Output "    Downloading: $($item.name)"
            $fileContent = Invoke-RestMethod -Uri $item.url -Headers @{"Accept"="application/vnd.github.v3+json"}
            $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContent.content))
            [System.IO.File]::WriteAllText($itemPath, $content)
        } elseif ($item.type -eq "dir") {
            DownloadDirectory -sourceUrl $item.url -targetPath $itemPath
        }
    }
}

Write-Output "=== Downloading android directory from xlist-io/xlist ==="

# 获取 android 目录内容
$android = Invoke-RestMethod -Uri "https://api.github.com/repos/xlist-io/xlist/contents/android" -Headers @{"Accept"="application/vnd.github.v3+json"}

Write-Output "Found $($android.Count) items in android/"

# 下载每个文件/目录
foreach ($item in $android) {
    $localPath = Join-Path $baseDir "android\$($item.name)"

    if ($item.type -eq "file") {
        Write-Output "Downloading file: $($item.name)"
        $fileContent = Invoke-RestMethod -Uri $item.url -Headers @{"Accept"="application/vnd.github.v3+json"}
        $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContent.content))

        # 保存到本地
        $parentDir = Split-Path $localPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        [System.IO.File]::WriteAllText($localPath, $content)
    } elseif ($item.type -eq "dir") {
        DownloadDirectory -sourceUrl $item.url -targetPath $localPath
    }
}

Write-Output "`n=== Download complete ==="

# 验证下载
Write-Output "`n=== Verifying android directory ==="
$downloadedFiles = Get-ChildItem -Path "android" -Recurse -File
Write-Output "Total files downloaded: $($downloadedFiles.Count)"
