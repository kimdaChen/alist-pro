#!/bin/bash

echo "========================================"
echo "XList APK 自动构建脚本"
echo "========================================"
echo ""

# 检查 Flutter 是否安装
if ! command -v flutter &> /dev/null; then
    echo "[错误] Flutter 未安装或未添加到 PATH"
    echo ""
    echo "请先安装 Flutter:"
    echo "1. 访问 https://docs.flutter.dev/get-started/install"
    echo "2. 下载并安装 Flutter SDK"
    echo "3. 将 Flutter 的 bin 目录添加到系统 PATH"
    echo "4. 重新打开终端"
    echo ""
    exit 1
fi

echo "[1/6] 检查 Flutter 版本..."
flutter --version
echo ""

echo "[2/6] 检查 Flutter 环境..."
flutter doctor -v
echo ""

echo "[3/6] 进入项目目录..."
if [ ! -d "xlist" ]; then
    echo "[错误] xlist 目录不存在"
    exit 1
fi
cd xlist

echo "[4/6] 获取 Flutter 依赖..."
echo ""
echo "正在安装 packages/fijkplayer 依赖..."
cd packages/fijkplayer
flutter pub get
if [ $? -ne 0 ]; then
    echo "[错误] fijkplayer 依赖安装失败"
    exit 1
fi
cd ../..

echo ""
echo "正在安装主项目依赖..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "[错误] 主项目依赖安装失败"
    exit 1
fi
echo ""

echo "[5/6] 开始构建 Release APK..."
echo ""
echo "这可能需要 5-15 分钟,请耐心等待..."
flutter build apk --release
if [ $? -ne 0 ]; then
    echo "[错误] APK 构建失败"
    echo ""
    echo "尝试清理缓存后重构建:"
    echo "1. 运行: flutter clean"
    echo "2. 删除 .pub-cache 目录"
    echo "3. 重新运行此脚本"
    exit 1
fi
echo ""

echo "[6/6] 查找生成的 APK..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo ""
    echo "========================================"
    echo "构建成功!"
    echo "========================================"
    echo ""
    echo "APK 文件位置:"
    echo "$(pwd)/build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    APK_PATH="$(pwd)/build/app/outputs/flutter-apk/app-release.apk"
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "文件大小: $APK_SIZE"
    echo ""
    echo "========================================"
    echo "修复内容:"
    echo "- 修复视频播放黑屏问题"
    echo "- 禁用 HEVC 硬解码以提升兼容性"
    echo "- 优化 MediaCodec 配置"
    echo "========================================"
    echo ""

    # 尝试打开文件管理器
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open -R "$APK_PATH"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "$(dirname "$APK_PATH")"
    fi
else
    echo "[错误] 未找到生成的 APK 文件"
    echo ""
    echo "请检查:"
    echo "1. 构建过程中是否有错误"
    echo "2. 是否成功运行了 flutter build apk 命令"
    echo "3. build/app/outputs/flutter-apk/ 目录是否存在"
fi

echo ""
