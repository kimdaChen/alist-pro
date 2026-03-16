# 如何通过 GitHub Actions 构建 APK

## 问题
原项目使用 `fijkplayer` 本地包依赖，导致 GitHub Actions CI 无法成功构建。

## 解决方案
已将播放器从 `fijkplayer` 替换为 Flutter 官方 `video_player` + `better_player`，这样可以：

✅ 支持 GitHub Actions CI/CD
✅ 自动硬件解码（无需手动配置）
✅ 视频缓存
✅ 字幕支持
✅ 多音轨支持
✅ 进度记录

## 方法一：使用 Git 推送（推荐）

### 1. 安装 Git
下载并安装: https://git-scm.com/download/win

### 2. 克隆或初始化仓库

**如果是你的仓库：**
```bash
# 克隆你的仓库（如果还没有）
git clone https://github.com/[YOUR_USERNAME]/xlist.git
cd xlist

# 复制修改后的文件到仓库中
```

**或者直接在当前目录操作：**
```bash
cd c:/Users/chenj/WorkBuddy/Claw
git init
git remote add origin https://github.com/[YOUR_USERNAME]/xlist.git
```

### 3. 配置 Git
```bash
git config user.name "Auto Build"
git config user.email "autobuild@xlist.dev"
```

### 4. 添加、提交和推送
```bash
# 方式 A: 使用 PowerShell 脚本（自动）
.\push_and_build.ps1

# 方式 B: 使用批处理脚本（自动）
.\push_and_build.bat

# 方式 C: 手动执行
git add .
git commit -m "fix: 替换 fijkplayer 为 video_player"
git push -u origin master
```

### 5. 查看构建状态
访问: https://github.com/[YOUR_USERNAME]/xlist/actions

### 6. 下载 APK
构建完成后，在 Actions 页面下载 `xlist-v{run_number}-fixed.apk`

---

## 方法二：直接在 GitHub 网页操作（无 Git）

### 1. 访问你的仓库
https://github.com/[YOUR_USERNAME]/xlist

### 2. 创建新分支
点击 "main" → 输入 "fix-player" → 点击 "Create branch"

### 3. 上传修改的文件

需要上传以下文件（替换现有文件）：

**核心文件：**
- `.github/workflows/build-apk.yml`
- `pubspec.yaml`
- `lib/helper/index.dart`
- `lib/helper/video_helper.dart` (新文件)
- `lib/pages/video_player_better/` (新文件夹)
  - `binding.dart`
  - `controller.dart`
  - `view.dart`
  - `index.dart`
- `lib/routes/app_pages.dart`
- `lib/services/player_notification_service.dart`

**文档文件（可选）：**
- `GITHUB_ACTIONS_BUILD_GUIDE.md`
- `push_and_build.bat`
- `push_and_build.ps1`

### 4. 上传步骤
1. 点击 "Add file" → "Upload files"
2. 将上面的文件拖拽到上传区域
3. 在 "Commit changes" 框中输入：
   ```
   fix: 替换 fijkplayer 为 video_player 以支持 GitHub Actions 构建

   - 使用官方 video_player 和 better_player
   - 移除本地 fijkplayer 依赖
   - 修复 GitHub Actions 构建失败问题
   - 支持硬件解码和视频缓存
   ```
4. 点击 "Commit changes"

### 5. 创建 Pull Request 并合并
1. 点击 "Compare & pull request"
2. 点击 "Create pull request"
3. 点击 "Merge pull request"
4. 点击 "Confirm merge"
5. 删除分支（可选）

### 6. 查看构建
访问 Actions 页面查看构建状态

---

## 修改的文件清单

### 必须修改的文件（10 个）：
1. `.github/workflows/build-apk.yml` - 简化 GitHub Actions 配置
2. `pubspec.yaml` - 更新依赖
3. `lib/helper/index.dart` - 更新 helper 导出
4. `lib/helper/video_helper.dart` - **新文件**
5. `lib/pages/video_player_better/binding.dart` - **新文件**
6. `lib/pages/video_player_better/controller.dart` - **新文件**
7. `lib/pages/video_player_better/view.dart` - **新文件**
8. `lib/pages/video_player_better/index.dart` - **新文件**
9. `lib/routes/app_pages.dart` - 更新路由
10. `lib/services/player_notification_service.dart` - 移除 fijkplayer 依赖

### 可选文档（4 个）：
- `GITHUB_ACTIONS_BUILD_GUIDE.md`
- `push_and_build.bat`
- `push_and_build.ps1`
- `INSTRUCTIONS.md`（本文件）

---

## 推送时可能遇到的问题

### 问题 1: 认证失败
**解决方法：** 使用 GitHub Personal Access Token
1. 访问: https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 选择权限: `repo`
4. 生成并复制 token

推送时：
```bash
git remote set-url origin https://[TOKEN]@github.com/[USERNAME]/[REPO].git
git push -u origin master
```

### 问题 2: 远程仓库不存在
**解决方法：** 先在 GitHub 创建仓库
1. 访问: https://github.com/new
2. 输入仓库名: `xlist`
3. 创建后复制仓库 URL

### 问题 3: 文件冲突
**解决方法：** 强制推送（谨慎使用）
```bash
git push -f origin master
```

---

## 验证构建是否成功

1. 访问: https://github.com/[YOUR_USERNAME]/xlist/actions
2. 查看最新的 workflow run
3. 状态应为 ✅ 绿色的 "Success"
4. 点击进入查看详情
5. 滚动到底部，下载 APK artifact

---

## APK 功能测试

构建完成后，测试以下功能：
- [ ] 视频播放正常
- [ ] 有声音有画面
- [ ] 硬件解码工作正常
- [ ] 进度条可拖动
- [ ] 横竖屏切换
- [ ] 字幕切换（如果有）
- [ ] 播放列表切换
- [ ] 播放模式（列表循环、单集循环）

---

## GitHub Actions 配置说明

当前配置：
- Flutter 版本: 3.16.0
- Java 版本: 17
- 构建环境: ubuntu-latest
- 触发条件: 推送到 master 分支
- APK 保留时间: 30 天

如需修改，编辑 `.github/workflows/build-apk.yml`

---

生成时间: 2026-03-10
