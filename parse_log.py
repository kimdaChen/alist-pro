import re

log_file = r'c:/Users/chenj/WorkBuddy/Claw/run_latest_logs/Build APK/6_Build Release APK.txt'

with open(log_file, encoding='utf-8', errors='replace') as f:
    content = f.read()

# Find the section around FAILURE
idx = content.find('FAILURE: Build failed')
if idx >= 0:
    # Get 3000 chars around the failure
    start = max(0, idx - 2000)
    snippet = content[start:idx+1000]
    lines = snippet.split('\n')
    for l in lines:
        m = re.match(r'.{33}Z (.*)', l)
        if m:
            print(m.group(1))
        else:
            print(l)
