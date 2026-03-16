$token = "ghp_1234567890abcdefghijklmnopqrstuvwxyz123456"
$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github.v3+json"
}

# 获取最新构建的详细信息
$runId = "22899165062"
Write-Output "Fetching run #22899165062..."
$runDetails = Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/actions/runs/$runId" -Headers $headers
Write-Output "Status: $($runDetails.status)"
Write-Output "Conclusion: $($runDetails.conclusion)"
Write-Output "Created: $($runDetails.created_at)"

# 下载构建日志
Write-Output "Downloading logs..."
Invoke-RestMethod -Uri "https://api.github.com/repos/kimdaChen/xlist/actions/runs/$runId/logs" -Headers $headers -OutFile "latest_build_log.zip"
Write-Output "Logs saved to latest_build_log.zip"
