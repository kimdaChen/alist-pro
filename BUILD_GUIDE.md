# 本地构建 APK 详细指南

由于 GitHub Actions 在处理本地包 (`packages/fijkplayer`) 时遇到问题,请在本地手动构建 APK。

## 前置条件检查

### 1. 检查是否已安装 Flutter

打开命令行(Windows 使用 PowerShell 或 CMD),运行:

```bash
flutter --version
```

如果未安装或版本过低,请访问: https://docs.flutter.dev/get-started/install

**推荐版本:** Flutter 3.16.0 或更高版本

### 2. 检查是否已安装 Android SDK

运行:

```bash
flutter doctor
```

查看 `Android toolchain` 部分,应该显示:
- ✅ Android SDK
- ✅ Android SDK Platform-tools
- ✅ Android SDK Build-Tools

如果缺少这些,需要:
- 安装 Android Studio (会自动包含 Android SDK)
- 或安装 Android SDK Command-line Tools
- 配置 `ANDROID_HOME` 环境变量

### 3. 接受 Android 许可证

```bash
flutter doctor --android-licenses
```

一路按 `y` 接受所有许可证。

## 构建步骤

### 步骤 1: 克隆仓库

```bash
# 克隆包含修复的仓库
git clone https://github.com/kimdaChen/xlist.git
cd xlist

# 确认当前在 master 分支(包含修复)
git branch
# 应该显示 * master
```

### 步骤 2: 获取依赖

```bash
# 获取 Flutter 依赖
flutter pub get

# 如果遇到问题,先进入 packages 目录
cd packages/fijkplayer
flutter pub get
cd ../..

# 再次获取主项目依赖
flutter pub get
```

### 步骤 3: 构建 APK

```bash
# 构建 Release 版本的 APK
flutter build apk --release
```

构建过程可能需要 5-15 分钟,取决于您的电脑性能。

### 步骤 4: 查找生成的 APK

构建成功后,APK 文件位于:

```
build/app/outputs/flutter-apk/app-release.apk
```

### 步骤 5: 安装到设备

#### 方法 A: 通过 USB 安装

```bash
# 连接 Android 设备,启用 USB 调试

# 检查设备是否连接
adb devices

# 安装 APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### 方法 B: 传输文件到设备

1. 将 `app-release.apk` 文件复制到 Android 设备
2. 在设备上点击 APK 文件进行安装
3. 如果提示"未知来源",需要在设置中允许安装未知应用

## 修复内容说明

本次修复解决了 Android 视频播放黑屏的问题:

### 修改的文件
- `lib/helper/fijk_helper.dart`

### 主要改动
1. **禁用 HEVC 硬解码** - 避免设备兼容性问题
2. **移除强制硬解码配置** - 让播放器自动选择最佳解码器
3. **保留 H.264 硬解码** - 兼容性好且性能高
4. **添加自动旋转和音频优化** - 提升播放体验

### 验证修复
安装新 APK 后,请测试:
- 播放各种格式的视频 (MP4, MKV, AVI, FLV)
- 确认画面正常显示(不再是黑屏)
- 确认音频正常播放
- 测试播放控制(暂停、拖动进度条等)

## 常见问题

### 问题 1: flutter 命令找不到

**解决方案:**
1. 确保 Flutter 已正确安装
2. 将 Flutter 的 `bin` 目录添加到 PATH 环境变量
3. 重新打开命令行窗口

### 问题 2: Android license not accepted

**解决方案:**
```bash
flutter doctor --android-licenses
```
按提示输入 `y` 接受所有许可证。

### 问题 3: Gradle 构建失败

**解决方案:**
```bash
# 清理缓存
flutter clean
cd android
./gradlew clean
cd ..

# 重新构建
flutter build apk --release
```

### 问题 4: packages/fijkplayer 依赖错误

**解决方案:**
```bash
# 单独安装 fijkplayer 依赖
cd packages/fijkplayer
flutter pub get
cd ../..
flutter pub get
```

### 问题 5: 构建时间过长

**说明:** Flutter 首次构建确实需要较长时间(5-15分钟),这是正常的。

**加速方法:**
1. 关闭杀毒软件对构建目录的实时扫描
2. 确保使用 SSD 硬盘
3. 分配更多内存给 Gradle(修改 `android/gradle.properties`):
   ```properties
   org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=4096m
   ```

## 构建成功后的文件

```
xlist/
├── build/
│   └── app/
│       └── outputs/
│           └── flutter-apk/
│               └── app-release.apk  ← 这就是您需要的 APK 文件
```

文件大小通常在 30-60 MB 之间。

## 其他构建选项

### 构建 Debug 版本(用于测试)
```bash
flutter build apk --debug
```
生成的文件: `build/app/outputs/flutter-apk/app-debug.apk`

### 构建 APK 分包(适用于应用商店)
```bash
flutter build apk --split-per-abi
```
会生成针对不同 CPU 架构的 APK:
- `app-armeabi-v7a-release.apk` (32位 ARM)
- `app-arm64-v8a-release.apk` (64位 ARM)
- `app-x86_64-release.apk` (x86 模拟器)

### 构建 App Bundle(用于 Google Play)
```bash
flutter build appbundle
```
生成的文件: `build/app/outputs/bundle/release/app-release.aab`

## 联系与支持

如果遇到其他问题:
- 查看 GitHub Issues: https://github.com/kimdaChen/xlist/issues
- 查看源项目文档: https://github.com/xlist-io/xlist

## 修复验证清单

安装新构建的 APK 后,请完成以下测试:

- [ ] 播放 MP4 视频文件,画面和声音都正常
- [ ] 播放 MKV 视频文件
- [ ] 播放 AVI 视频文件
- [ ] 播放 FLV 视频文件
- [ ] 播放控制(播放/暂停)正常工作
- [ ] 进度条拖动正常工作
- [ ] 全屏切换正常工作
- [ ] 字幕显示正常(如果有)
- [ ] 视频不再出现黑屏问题

---

**文档更新时间:** 2026-03-10
**GitHub 仓库:** https://github.com/kimdaChen/xlist
**最新提交:** c40b67e88da7887a0a9b7e7c49c48568987ada30 (已包含视频播放修复)
