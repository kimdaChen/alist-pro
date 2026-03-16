$bytes = [System.IO.File]::ReadAllBytes("build_22898072646.zip")
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
$lines = $text -split "`n"

Write-Host "=== Lines 248-285 (after Listing files) ===" -ForegroundColor Yellow
for ($i = 248; $i -le [Math]::Min(285, $lines.Count - 1); $i++) {
    Write-Host "[$i] $($lines[$i])"
}
