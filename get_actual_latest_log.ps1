# 获取最新的构建 ID
$runs = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/actions/runs?per_page=5" -Headers @{"Accept"="application/vnd.github.v3+json"}
$latestRun = $runs.workflow_runs[0]
Write-Output "Latest run ID: $($latestRun.id)"
Write-Output "Status: $($latestRun.status)"
Write-Output "Conclusion: $($latestRun.conclusion)"

# 获取 job ID
$runId = $latestRun.id
$runDetails = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/actions/runs/$runId" -Headers @{"Accept"="application/vnd.github.v3+json"}
$jobId = $runDetails.jobs[0].id
Write-Output "Job ID: $jobId"

# 下载日志
Write-Output "Downloading logs for job $jobId..."
$logFile = "build_$runId.zip"
Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/actions/jobs/$jobId/logs" -Headers @{"Accept"="application/vnd.github.v3+json"} -OutFile $logFile
Write-Output "Logs saved to $logFile"

# 解压并查找错误
$tempDir = "temp_extract_$runId"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
Expand-Archive -Path $logFile -DestinationPath $tempDir -Force

Write-Output "`n=== Searching for errors ==="
Get-ChildItem -Path $tempDir -Recurse -Filter "*.txt" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "error|Error|ERROR|fail|Fail|FAIL|failed") {
        Write-Output "Found in $($_.Name):"
        $content -split "`n" | Select-String -Pattern "error|Error|ERROR|fail|Fail|FAIL|failed|Expected" | Select-Object -First 5
    }
}

# 清理
Remove-Item -Path $tempDir -Recurse -Force
