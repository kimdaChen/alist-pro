# 检查 GitHub 上的 lib 目录详细内容
Write-Output "=== GitHub lib/ directory details ==="
$lib = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/contents/lib" -Headers @{"Accept"="application/vnd.github.v3+json"}

$lib | ForEach-Object {
    Write-Output "[$($_.type)] $($_.name)"
    if ($_.type -eq "dir") {
        try {
            $subContents = Invoke-RestMethod -Uri $_.url -Headers @{"Accept"="application/vnd.github.v3+json"}
            Write-Output "  Contains $($subContents.Count) items:"
            $subContents | Select-Object -First 10 | ForEach-Object {
                Write-Output "    - $($_.name)"
            }
            if ($subContents.Count -gt 10) {
                Write-Output "    ... and $($subContents.Count - 10) more"
            }
        } catch {
            Write-Output "  Error: $_"
        }
    }
}

Write-Output "`n=== Local lib/ directory count ==="
$localFiles = Get-ChildItem -Path "lib" -Recurse -File
Write-Output "Total files in local lib/: $($localFiles.Count)"

Write-Output "`n=== Checking video_player pages ==="
$pages = Get-ChildItem -Path "lib/pages" -Directory | Where-Object { $_.Name -like "*video*" }
Write-Output "Video-related pages:"
$pages | ForEach-Object { Write-Output "  - $($_.Name)" }
