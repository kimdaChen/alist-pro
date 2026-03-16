# 尝试从原始仓库下载 android 目录
Write-Output "=== Downloading from original xlist-io/xlist repository ==="

# 检查原始仓库
try {
    $originalRepo = Invoke-RestMethod -Uri "https://api.github.com/repos/xlist-io/xlist/contents/android" -Headers @{"Accept"="application/vnd.github.v3+json"}
    Write-Output "Original repository android/ directory found!"
    Write-Output "Items: $($originalRepo.Count)"
} catch {
    Write-Output "Original repository not accessible: $_"
}

# 尝试从 kimdaChen/xlist 获取
try {
    $kimdaRepo = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/git/refs/heads/master" -Headers @{"Accept"="application/vnd.github.v3+json"}
    Write-Output "`nCurrent master branch SHA: $($kimdaRepo.object.sha)"

    # 获取完整的 tree
    $treeUrl = "https://api.github.com/repos/kimdaChen/xlist/git/trees/$($kimdaRepo.object.sha)?recursive=1"
    $tree = Invoke-RestMethod -Uri $treeUrl -Headers @{"Accept"="application/vnd.github.v3+json"}
    Write-Output "Total items in tree: $($tree.tree.Count)"

    # 查找 android 相关文件
    Write-Output "`n=== Android-related files in repository ==="
    $androidFiles = $tree.tree | Where-Object { $_.path -like "android/*" }
    if ($androidFiles) {
        Write-Output "Found $($androidFiles.Count) android files:"
        $androidFiles | Select-Object -First 20 | ForEach-Object {
            Write-Output "  $($_.path)"
        }
    } else {
        Write-Output "No android files found!"
    }
} catch {
    Write-Output "Error getting tree: $_"
}
