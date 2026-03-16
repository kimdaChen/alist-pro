$GIT_PATH = "C:\Program Files\Git\bin\git.exe"
$BASE_DIR = "c:/Users/chenj/WorkBuddy/Claw"

Write-Host "Reverting to original video player and pushing..." -ForegroundColor Cyan

Set-Location $BASE_DIR

& $GIT_PATH add -A
& $GIT_PATH commit -m "fix: revert to original video player, remove better_player references"
& $GIT_PATH push origin master

Write-Host "Done!" -ForegroundColor Green
