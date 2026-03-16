#!/bin/bash

echo "=== Fixing line endings for AndroidManifest.xml ==="
dos2unix android/app/src/main/AndroidManifest.xml 2>/dev/null || true

echo "=== Adding all modified files ==="
git add android/app/src/main/AndroidManifest.xml
git add android/app/src/main/res/xml/provider_paths.xml
git add android/app/src/main/res/values/styles.xml
git add android/app/src/main/res/values/strings.xml
git add .gitignore

echo "=== Committing changes ==="
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

echo "=== Pushing to GitHub ==="
git push origin master

echo "=== Done! ==="
echo "Check build status at: https://github.com/kimdaChen/xlist/actions"
