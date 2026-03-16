import zipfile
import sys

sys.stdout.reconfigure(encoding='utf-8')

z = zipfile.ZipFile('build_log.zip')

# 读取 "7_Build APK.txt"
if 'Build APK/7_Build APK.txt' in z.namelist():
    content = z.read('Build APK/7_Build APK.txt').decode('utf-8', errors='ignore')
    lines = content.split('\n')

    # 查找错误
    print('=== ERROR LINES ===')
    for i, line in enumerate(lines):
        if any(keyword in line.lower() for keyword in ['error', 'exception', 'fail', 'could not resolve', 'not found']):
            print(f'{i}: {line}')

    print('\n=== LAST 50 LINES ===')
    for line in lines[-50:]:
        print(line)
