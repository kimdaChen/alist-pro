import zipfile

z = zipfile.ZipFile('build_log.zip')
print('Files in zip:')
for name in sorted(z.namelist()):
    size = z.getinfo(name).file_size
    print(f'{name} - {size} bytes')
