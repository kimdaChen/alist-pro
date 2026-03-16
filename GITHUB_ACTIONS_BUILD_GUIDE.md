# GitHub Actions 构建指南

## 问题解决方案

已将 `fijkplayer` 本地包替换为 Flutter 官方 `video_player` 和 `better_player`，以解决 GitHub Actions 构建失败的问题。

## 代码修改

### 1. 更新 pubspec.yaml
```yaml
# 移除本地 fijkplayer 依赖
# fijkplayer:
#   path: packages/fijkplayer

# 添加官方视频播放器
video_player: ^2.8.2
chewie: ^1.7.4
better_player: ^0.0.83
```

### 2. 创建新的播放器模块
- `lib/helper/video_helper.dart` - 视频播放器助手
- `lib/pages/video_player_better/` - 新的播放器页面
  - `controller.dart` - 使用 Better Player 的控制器
  - `view.dart` - 播放器视图
  - `binding.dart` - 依赖绑定
  - `index.dart` - 模块导出

### 3. 更新路由配置
- `lib/routes/app_pages.dart` - 使用新的 VideoPlayerBetterPage 和 VideoPlayerBetterBinding

### 4. 简化通知服务
- `lib/services/player_notification_service.dart` - 移除 fijkplayer 依赖

### 5. 更新 GitHub Actions 工作流
- `.github/workflows/build-apk.yml` - 简化构建流程，移除 CI 专用 pubspec

## 如何构建 APK

### 方法 1: 通过 GitHub Actions（推荐）

1. **推送代码到 GitHub**：
   ```bash
   git add .
   git commit -m "fix: 替换 fijkplayer 为 video_player 以支持 GitHub Actions 构建"
   git push origin master
   ```

2. **触发构建**：
   - 推送到 `master` 分支会自动触发构建
   - 或在 GitHub Actions 页面手动触发 `workflow_dispatch`

3. **下载 APK**：
   - 构建完成后，在 Actions 页面下载 artifacts
   - APK 文件名：`xlist-v{run_number}-fixed.apk`

### 方法 2: 本地构建

1. **安装 Flutter**：
   ```bash
   # 下载 Flutter SDK
   flutter --version

   # 配置环境变量
   export PATH="$PATH:/path/to/flutter/bin"
   ```

2. **获取依赖**：
   ```bash
   cd c:/Users/chenj/WorkBuddy/Claw
   flutter pub get
   ```

3. **构建 APK**：
   ```bash
   flutter build apk --release
   ```

4. **APK 位置**：
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

## 为什么使用 video_player 而不是 fijkplayer？

### fijkplayer 的问题
- 使用本地包依赖（`path: packages/fijkplayer`）
- GitHub Actions CI 无法正确解析本地包路径
- 需要复杂的 CI 配置和预编译步骤

### video_player 的优势
- Flutter 官方支持，稳定可靠
- 从 pub.dev 安装，无需本地依赖
- 完美支持 GitHub Actions CI/CD
- Better Player 提供更多高级功能（缓存、字幕、音频轨等）

## Better Player 功能特性

- ✅ 硬件解码支持（自动选择最佳解码器）
- ✅ 视频缓存
- ✅ 字幕支持（SRT, VTT, ASS）
- ✅ 多音轨支持
- ✅ 后台播放控制
- ✅ 进度记录
- ✅ 播放列表支持
- ✅ 播放模式（列表循环、单集循环、随机播放）
- ✅ 全屏支持
- ✅ 横竖屏切换

## 注意事项

1. **旧播放器保留**：`lib/pages/video_player/` 文件夹保留原 fijkplayer 实现，可作为参考或回退方案

2. **兼容性**：Better Player 支持的 Android 版本为 Android 4.4+ (API 19+)

3. **性能**：Better Player 会自动选择最佳解码器（硬解码优先），无需手动配置

## 下一步

1. 推送代码到 GitHub
2. 等待 GitHub Actions 完成构建
3. 下载并测试 APK
4. 如有问题，查看构建日志进行调试

## 故障排查

### GitHub Actions 构建失败
- 检查 Actions 日志中的错误信息
- 确认依赖版本是否正确
- 验证 pubspec.yaml 格式

### APK 视频播放问题
- 测试不同格式的视频（MP4, WebM, MKV）
- 检查设备日志（`adb logcat`）
- 验证视频 URL 可访问性

---

生成时间: 2026-03-10
