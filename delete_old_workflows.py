import os

old_files = [
    '.github/workflows/build-android.yml',
    '.github/workflows/build-android-new.yml',
    '.github/workflows/build-apk.yml',
    '.github/workflows/build-apk-clean.yml'
]

for f in old_files:
    if os.path.exists(f):
        os.remove(f)
        print(f"Deleted: {f}")

print("All old workflow files deleted!")
