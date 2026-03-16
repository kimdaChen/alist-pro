$bytes = [System.IO.File]::ReadAllBytes("build_22899101243.zip")
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
$lines = $text -split "`n"

Write-Host "=== Lines 288-320 ===" -ForegroundColor Yellow
for ($i = 288; $i -le [Math]::Min(320, $lines.Count - 1); $i++) {
    Write-Host "[$i] $($lines[$i])"
}
