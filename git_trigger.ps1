$GIT_PATH = "C:\Program Files\Git\bin\git.exe"
$BASE_DIR = "c:/Users/chenj/WorkBuddy/Claw"

Set-Location $BASE_DIR

# Create an empty commit to trigger build
& $GIT_PATH commit --allow-empty -m "trigger: build"
& $GIT_PATH push origin master

Write-Host "Triggered!" -ForegroundColor Green
