import zipfile
import sys

z = zipfile.ZipFile('build_log.zip')

for name in z.namelist():
    if 'Build APK' in name and '9_Build' in name:
        content = z.read(name).decode('utf-8', errors='ignore')
        lines = content.split('\n')

        print(f'\n=== Last 50 lines of {name} ===')
        for line in lines[-50:]:
            print(line)
        break
