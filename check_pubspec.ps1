Write-Host "Checking pubspec.yaml..." -ForegroundColor Cyan

$pubspec = Get-Content "pubspec.yaml" -Raw

Write-Host "`nVideo player dependencies:" -ForegroundColor Yellow
if ($pubspec -match "video_player:\s*\S+") {
    Write-Host "  video_player: $($matches[1])" -ForegroundColor Green
} else {
    Write-Host "  video_player: NOT FOUND" -ForegroundColor Red
}

if ($pubspec -match "better_player:\s*\S+") {
    Write-Host "  better_player: $($matches[1])" -ForegroundColor Green
} else {
    Write-Host "  better_player: NOT FOUND" -ForegroundColor Red
}

if ($pubspec -match "chewie:\s*\S+") {
    Write-Host "  chewie: $($matches[1])" -ForegroundColor Green
} else {
    Write-Host "  chewie: NOT FOUND" -ForegroundColor Red
}

if ($pubspec -match "fijkplayer:") {
    Write-Host "  fijkplayer: FOUND (should be removed!)" -ForegroundColor Red
} else {
    Write-Host "  fijkplayer: REMOVED (good!)" -ForegroundColor Green
}

Write-Host "`nFlutter SDK version:" -ForegroundColor Yellow
if ($pubspec -match "flutter:\s*\n\s* sdk:\s*flutter") {
    Write-Host "  flutter: sdk (good!)" -ForegroundColor Green
}

Write-Host "`n" -ForegroundColor Cyan
