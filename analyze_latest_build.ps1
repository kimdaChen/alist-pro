Write-Output "=== Analyzing latest build log ==="

$tempDir = "temp_extract_latest"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Expand-Archive -Path "build_latest.zip" -DestinationPath $tempDir -Force

    Write-Output "`n=== Searching for errors ==="
    Get-ChildItem -Path $tempDir -Recurse -Filter "*.txt" | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $lines = $content -split "`n"

        # 查找包含关键错误的行
        $errorLines = $lines | Where-Object {
            $_ -match "error|Error|ERROR|fail|Fail|FAIL|failed|exception|Exception|EXCEPTION" -and
            $_ -notmatch "Setup.*success" -and
            $_ -notmatch "Post.*success" -and
            $_ -notmatch "telemetry"
        }

        if ($errorLines.Count -gt 0) {
            Write-Output "`nFile: $($_.Name)"
            $errorLines | Select-Object -First 10 | ForEach-Object {
                Write-Output "  $_"
            }
        }
    }

} catch {
    Write-Output "Error analyzing logs: $_"
}

# 清理
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
