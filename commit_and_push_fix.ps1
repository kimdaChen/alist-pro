# Fix and push to GitHub

Write-Host "=== Adding all modified files ===" -ForegroundColor Green

git add android/app/src/main/AndroidManifest.xml
git add android/app/src/main/res/xml/provider_paths.xml
git add android/app/src/main/res/values/styles.xml
git add android/app/src/main/res/values/strings.xml
git add .gitignore

Write-Host "=== Committing changes ===" -ForegroundColor Green

git commit -m "Fix AndroidManifest.xml and add missing resource files

- Add android:enableOnBackInvokedCallback=true for Android 13+ support
- Add Android 13+ permissions (POST_NOTIFICATIONS, READ_MEDIA_*)
- Fix WRITE_EXTERNAL_STORAGE maxSdkVersion to 32
- Disable Impeller for better compatibility
- Remove tools:ignore attributes that cause parsing issues
- Add file:// scheme to queries
- Add missing provider_paths.xml, styles.xml, strings.xml
- Update .gitignore to exclude local.properties
- Fix line endings for Linux compatibility"

Write-Host "=== Pushing to GitHub ===" -ForegroundColor Green

git push origin master

Write-Host "=== Done! ===" -ForegroundColor Green
Write-Host "Check build status at: https://github.com/kimdaChen/xlist/actions" -ForegroundColor Cyan
