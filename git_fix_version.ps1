$GIT_PATH = "C:\Program Files\Git\bin\git.exe"
$BASE_DIR = "c:/Users/chenj/WorkBuddy/Claw"

Write-Host "Updating Flutter version and pushing..." -ForegroundColor Cyan

Set-Location $BASE_DIR

& $GIT_PATH add .github/workflows/build-apk.yml
& $GIT_PATH commit -m "fix: update Flutter to 3.24.0 for Dart 3.5 compatibility"
& $GIT_PATH push origin master

Write-Host "Done!" -ForegroundColor Green
