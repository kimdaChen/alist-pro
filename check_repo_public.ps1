# 检查公开的 GitHub 仓库内容（不需要 token）
Write-Output "=== Checking Repository Files ==="

# 获取根目录文件
$root = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/contents/" -Headers @{"Accept"="application/vnd.github.v3+json"}
Write-Output "`n=== Root Directory Files ==="
$root | ForEach-Object {
    Write-Output "$($_.name) ($($_.type))"
}

# 检查 pubspec.yaml
Write-Output "`n=== Checking for pubspec.yaml ==="
$pubspec = $root | Where-Object { $_.name -eq "pubspec.yaml" }
if ($pubspec) {
    Write-Output "pubspec.yaml FOUND!"
    Write-Output "SHA: $($pubspec.sha)"
} else {
    Write-Output "pubspec.yaml NOT FOUND!"
}

# 检查 lib 目录
Write-Output "`n=== Checking lib/ directory ==="
$lib = $root | Where-Object { $_.name -eq "lib" }
if ($lib) {
    Write-Output "lib/ directory FOUND!"
    try {
        $libContents = Invoke-RestMethod -Uri $lib.url -Headers @{"Accept"="application/vnd.github.v3+json"}
        Write-Output "Files in lib/: $($libContents.Count)"
        $libContents | Select-Object -First 10 | ForEach-Object {
            Write-Output "  $($_.name)"
        }
    } catch {
        Write-Output "Error getting lib contents: $_"
    }
} else {
    Write-Output "lib/ directory NOT FOUND!"
}

# 检查 github/workflows
Write-Output "`n=== Checking .github/workflows/ ==="
$github = $root | Where-Object { $_.name -eq ".github" }
if ($github) {
    $githubContents = Invoke-RestMethod -Uri $github.url -Headers @{"Accept"="application/vnd.github.v3+json"}
    $workflows = $githubContents | Where-Object { $_.name -eq "workflows" }
    if ($workflows) {
        $workflowContents = Invoke-RestMethod -Uri $workflows.url -Headers @{"Accept"="application/vnd.github.v3+json"}
        Write-Output "Workflow files:"
        $workflowContents | ForEach-Object {
            Write-Output "  $($_.name)"
        }
    }
}
