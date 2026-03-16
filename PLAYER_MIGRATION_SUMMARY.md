# 视频播放器迁移总结

## 问题描述

xlist 项目使用 `fijkplayer` 本地包依赖（`path: packages/fijkplayer`），这导致 GitHub Actions CI 无法成功构建，因为：

1. 本地包路径在 CI 环境中无法正确解析
2. fijkplayer 的本地配置与远程仓库结构不兼容
3. 需要复杂的预编译和缓存配置

## 解决方案

将播放器从 `fijkplayer` 迁移到 **Flutter 官方 video_player** + **better_player**。

### 为什么选择 better_player？

- ✅ 基于 video_player，兼容官方 API
- ✅ 支持硬件解码（自动选择最佳解码器）
- ✅ 内置视频缓存功能
- ✅ 支持多种字幕格式（SRT, VTT, ASS）
- ✅ 支持多音轨
- ✅ 支持后台播放和通知栏控制
- ✅ 从 pub.dev 安装，无需本地依赖
- ✅ 完美支持 GitHub Actions CI/CD

## 代码修改详情

### 1. pubspec.yaml 依赖更新

```yaml
# 移除
# fijkplayer:
#   path: packages/fijkplayer

# 添加
video_player: ^2.8.2
chewie: ^1.7.4
better_player: ^0.0.83
```

### 2. 新增文件（7 个）

**lib/helper/video_helper.dart**
- Better Player 配置辅助函数
- 播放器选项管理
- 时间格式化工具

**lib/pages/video_player_better/binding.dart**
- GetX 依赖绑定

**lib/pages/video_player_better/controller.dart**
- 使用 Better Player 的控制器
- 实现以下功能：
  - 视频加载和播放
  - 进度记录（每 5 秒保存）
  - 播放列表切换
  - 字幕切换
  - 播放模式（列表循环、单集循环、随机）
  - 屏幕常亮控制
  - 后台播放处理

**lib/pages/video_player_better/view.dart**
- UI 界面
- Better Player 播放器组件
- 播放列表显示
- 播放模式切换按钮

**lib/pages/video_player_better/index.dart**
- 模块导出文件

**push_and_build.ps1**
- PowerShell 自动提交脚本

**push_and_build.bat**
- 批处理自动提交脚本

### 3. 修改文件（3 个）

**lib/helper/index.dart**
- 从 `export 'fijk_helper.dart'` 改为 `export 'video_helper.dart'`

**lib/routes/app_pages.dart**
- 导入从 `video_player` 改为 `video_player_better`
- 路由配置从 `VideoPlayerPage` 改为 `VideoPlayerBetterPage`
- 绑定从 `VideoPlayerBinding` 改为 `VideoPlayerBetterBinding`

**lib/services/player_notification_service.dart**
- 移除 `import 'package:fijkplayer/fijkplayer.dart'`
- 移除 FijkState 相关逻辑
- 简化通知服务，移除 fijkplayer 特定代码
- 保留音频播放器支持

**lib/pages/video_player/** （保留但不使用）
- 原有的 fijkplayer 实现保留作为参考
- 可在需要时回退

**.github/workflows/build-apk.yml**
- 移除 `Use CI-specific pubspec` 步骤
- 直接使用主 pubspec.yaml

### 4. 文档文件（4 个）

- `GITHUB_ACTIONS_BUILD_GUIDE.md` - GitHub Actions 构建指南
- `INSTRUCTIONS.md` - 详细操作说明
- `PLAYER_MIGRATION_SUMMARY.md` - 本文件
- `FIX_SUMMARY.md` - 之前的修复总结（保留）

## Better Player 配置

### 硬件解码
Better Player 会自动选择最佳解码器，无需手动配置：

```dart
BetterPlayerConfiguration(
  autoPlay: true,
  looping: false,
  fit: BoxFit.contain,
  autoDetectFullscreenAspectRatio: true,
  autoDetectFullscreenDeviceOrientation: true,
  handleLifecycle: true,
)
```

### 视频缓存
```dart
BetterPlayerCacheConfiguration(
  useCache: true,
  preCacheSize: 10 * 1024 * 1024,      // 10MB 预缓存
  maxCacheSize: 100 * 1024 * 1024,      // 100MB 最大缓存
  maxCacheFileSize: 50 * 1024 * 1024,   // 50MB 单文件限制
)
```

### 通知栏控制
```dart
BetterPlayerNotificationConfiguration(
  showNotification: true,
  title: '视频播放',
  author: 'Xlist',
  imageUrl: '封面URL',
)
```

## 功能对比

| 功能 | fijkplayer | better_player |
|------|------------|---------------|
| 硬件解码 | ✅ 需手动配置 | ✅ 自动选择 |
| 视频缓存 | ❌ 需额外配置 | ✅ 内置支持 |
| 字幕支持 | ✅ SRT/VTT | ✅ SRT/VTT/ASS |
| 多音轨 | ✅ | ✅ |
| 后台播放 | ✅ 需额外配置 | ✅ 内置支持 |
| CI/CD | ❌ 本地包问题 | ✅ 完美支持 |
| 文档质量 | ⚠️ 一般 | ✅ 详细 |
| 社区支持 | ⚠️ 较小 | ✅ 活跃 |

## 构建和部署

### GitHub Actions 工作流

```yaml
name: Build Android APK

on:
  push:
    branches: [master]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/兼容
      - uses: actions/setup-java@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
```

### 手动推送步骤

1. 安装 Git: https://git-scm.com/download/win
2. 克隆仓库: `git clone https://github.com/username/xlist.git`
3. 复制修改后的文件
4. 运行提交脚本: `.\push_and_build.ps1`
5. 查看 Actions: https://github.com/username/xlist/actions
6. 下载 APK

## 测试建议

### 功能测试清单
- [ ] 视频播放正常（有画面有声音）
- [ ] 进度条可拖动
- [ ] 横竖屏切换
- [ ] 播放列表切换
- [ ] 字幕切换（如果有字幕）
- [ ] 播放模式（列表循环、单集循环）
- [ ] 进度记录（播放后关闭再打开，进度是否保存）
- [ ] 后台播放（切换到后台是否继续播放）
- [ ] 通知栏控制

### 兼容性测试
- [ ] 不同 Android 版本（4.4, 5.0, 6.0, 7.0, 8.0, 9.0, 10, 11, 12, 13）
- [ ] 不同屏幕尺寸
- [ ] 不同视频格式（MP4, WebM, MKV）
- [ ] 不同分辨率（720p, 1080p, 4K）

## 回滚方案

如果 better_player 遇到问题，可以快速回滚到 fijkplayer：

1. 恢复 `pubspec.yaml` 中的 fijkplayer 依赖
2. 恢复 `lib/helper/index.dart` 导出
3. 恢复 `lib/routes/app_pages.dart` 路由配置
4. 恢复 `lib/services/player_notification_service.dart`

## 已知限制

1. **音频通知控制**: Better Player 的音频通知控制与原实现不同，当前版本简化了此功能
2. **播放器通知**: 音频播放器的通知控制保留，视频播放器的通知由 Better Player 管理

## 下一步计划

1. ✅ 代码迁移完成
2. ⏳ 推送到 GitHub
3. ⏳ GitHub Actions 构建
4. ⏳ 测试 APK
5. ⏳ 根据测试反馈优化
6. ⏳ 发布新版本

## 贡献者

- 代码迁移: Auto Build
- 文档: Auto Build

## 许可证

与原项目保持一致

---

生成时间: 2026-03-10
