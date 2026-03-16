@echo off
chcp 65001 >nul
echo ========================================
echo XList APK 自动构建脚本
echo ========================================
echo.

REM 检查 Flutter 是否安装
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] Flutter 未安装或未添加到 PATH
    echo.
    echo 请先安装 Flutter:
    echo 1. 访问 https://docs.flutter.dev/get-started/install
    echo 2. 下载并安装 Flutter SDK
    echo 3. 将 Flutter 的 bin 目录添加到系统 PATH
    echo 4. 重新打开命令行窗口
    echo.
    pause
    exit /b 1
)

echo [1/6] 检查 Flutter 版本...
flutter --version
echo.

echo [2/6] 检查 Flutter 环境...
flutter doctor -v
echo.

echo [3/6] 进入项目目录...
if not exist "xlist" (
    echo [错误] xlist 目录不存在
    pause
    exit /b 1
)
cd xlist

echo [4/6] 获取 Flutter 依赖...
echo.
echo 正在安装 packages/fijkplayer 依赖...
cd packages\fijkplayer
call flutter pub get
if %errorlevel% neq 0 (
    echo [错误] fijkplayer 依赖安装失败
    pause
    exit /b 1
)
cd ..\..

echo.
echo 正在安装主项目依赖...
call flutter pub get
if %errorlevel% neq 0 (
    echo [错误] 主项目依赖安装失败
    pause
    exit /b 1
)
echo.

echo [5/6] 开始构建 Release APK...
echo.
echo 这可能需要 5-15 分钟,请耐心等待...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo [错误] APK 构建失败
    echo.
    echo 尝试清理缓存后重构建:
    echo 1. 运行: flutter clean
    echo 2. 删除 .pub-cache 目录
    echo 3. 重新运行此脚本
    pause
    exit /b 1
)
echo.

echo [6/6] 查找生成的 APK...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ========================================
    echo 构建成功!
    echo ========================================
    echo.
    echo APK 文件位置:
    echo %cd%\build\app\outputs\flutter-apk\app-release.apk
    echo.
    set APK_PATH=%cd%\build\app\outputs\flutter-apk\app-release.apk

    for %%A in ("%APK_PATH%") do set APK_SIZE=%%~zA
    set /a APK_SIZE_MB=%APK_SIZE% / 1048576
    echo 文件大小: %APK_SIZE_MB% MB
    echo.
    echo ========================================
    echo 修复内容:
    echo - 修复视频播放黑屏问题
    echo - 禁用 HEVC 硬解码以提升兼容性
    echo - 优化 MediaCodec 配置
    echo ========================================
    echo.
    explorer /select,"%APK_PATH%"
) else (
    echo [错误] 未找到生成的 APK 文件
    echo.
    echo 请检查:
    echo 1. 构建过程中是否有错误
    echo 2. 是否成功运行了 flutter build apk 命令
    echo 3. build/app/outputs/flutter-apk/ 目录是否存在
)

echo.
pause
