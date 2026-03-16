import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:xlist/gen/index.dart';
import 'package:xlist/helper/index.dart';
import 'package:xlist/common/index.dart';
import 'package:xlist/constants/index.dart';
import 'package:xlist/components/index.dart';
import 'package:xlist/themes.dart';
import 'package:xlist/pages/audio_player/index.dart';

class AudioPlayerPage extends GetView<AudioPlayerController> {
  const AudioPlayerPage({Key? key}) : super(key: key);

  /// 更多操作菜单
  Widget _buildMenuButton() {
    List<PullDownMenuEntry> items = [
      PullDownMenuItem(
        title: 'favorite'.tr,
        icon: CupertinoIcons.heart,
        onTap: () => controller.favorite(),
      ),
      PullDownMenuDivider.large(),
      PullDownMenuItem(
        title: 'play_speed'.tr,
        icon: CupertinoIcons.speedometer,
        onTap: () => controller.changeSpeed(),
      ),
      PullDownMenuItem(
        title: 'pull_down_copy_link'.tr,
        icon: CupertinoIcons.link,
        onTap: () => controller.copyLink(),
      ),
      PullDownMenuItem(
        title: 'pull_down_download_file'.tr,
        icon: CupertinoIcons.cloud_download,
        onTap: () => controller.download(),
      ),
    ];

    return PullDownButton(
      itemBuilder: (context) => items,
      buttonBuilder: (context, showMenu) => _CircleIconButton(
        icon: Icons.more_horiz_rounded,
        onTap: showMenu,
        isLight: true,
      ),
    );
  }

  /// 封面（大圆角，带旋转动画感）
  Widget _buildCover({double size = 300}) {
    return Obx(() {
      final thumb = controller.object.value.thumb ?? '';
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.12),
          boxShadow: [
            BoxShadow(
              color: Themes.primaryPurple.withOpacity(0.4),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.12),
          child: thumb.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: thumb,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _buildDefaultCover(size),
                  errorWidget: (_, __, ___) => _buildDefaultCover(size),
                )
              : _buildDefaultCover(size),
        ),
      );
    });
  }

  Widget _buildDefaultCover(double size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.music_note_rounded,
          color: Colors.white.withOpacity(0.8),
          size: size * 0.38,
        ),
      ),
    );
  }

  /// 单曲播放视图
  Widget _buildSingleView(double coverSize) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: CommonUtils.isPad ? 20 : 60.h),
          Center(child: _buildCover(size: coverSize)),
          SizedBox(height: CommonUtils.isPad ? 32 : 64.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CommonUtils.isPad ? 24 : 60.w,
            ),
            child: Obx(() => Text(
                  CommonUtils.formatFileNme(controller.currentName.value),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? const Color(0xFFE8E8FF)
                        : const Color(0xFF1A1A2E),
                    fontSize: CommonUtils.isPad ? 20 : 40.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                )),
          ),
          SizedBox(height: CommonUtils.isPad ? 8 : 16.h),
        ],
      ),
    );
  }

  /// 播放列表视图
  Widget _buildPlaylistView(double coverSize) {
    final smallCover = coverSize * 0.42;
    return Column(
      children: [
        SizedBox(height: CommonUtils.isPad ? 16 : 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: CommonUtils.isPad ? 20 : 50.w),
          child: Row(
            children: [
              _buildCover(size: smallCover),
              SizedBox(width: CommonUtils.isPad ? 16 : 32.w),
              Expanded(
                child: Obx(() => Text(
                      CommonUtils.formatFileNme(controller.currentName.value),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Get.isDarkMode
                            ? const Color(0xFFE8E8FF)
                            : const Color(0xFF1A1A2E),
                        fontSize: CommonUtils.isPad ? 17 : 34.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    )),
              ),
            ],
          ),
        ),
        SizedBox(height: CommonUtils.isPad ? 20 : 48.h),
        Expanded(
          child: Obx(() => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.objects.length,
                padding: EdgeInsets.symmetric(
                  horizontal: CommonUtils.isPad ? 16 : 40.w,
                ),
                itemBuilder: (context, index) {
                  final isCurrent = controller.currentIndex.value == index;
                  final isDark = Get.isDarkMode;
                  return GestureDetector(
                    onTap: () => controller.changePlaylist(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(vertical: CommonUtils.isPad ? 3 : 6.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: CommonUtils.isPad ? 14 : 28.w,
                        vertical: CommonUtils.isPad ? 10 : 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Themes.primaryPurple.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          CommonUtils.isPad ? 12 : 24.r,
                        ),
                        border: isCurrent
                            ? Border.all(
                                color: Themes.primaryPurple.withOpacity(0.4),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          if (isCurrent)
                            Padding(
                              padding: EdgeInsets.only(right: CommonUtils.isPad ? 8 : 16.w),
                              child: Icon(
                                Icons.equalizer_rounded,
                                color: Themes.primaryPurple,
                                size: CommonUtils.isPad ? 18 : 36.sp,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              CommonUtils.formatFileNme(
                                  controller.objects[index].name ?? ''),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isCurrent
                                    ? Themes.primaryPurple
                                    : isDark
                                        ? const Color(0xFFD0D0F0)
                                        : const Color(0xFF2A2A3E),
                                fontSize: CommonUtils.isPad ? 14 : 28.sp,
                                fontWeight: isCurrent
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }

  /// 进度条
  Widget _buildSlider() {
    double duration =
        controller.duration.value.inMilliseconds.toDouble();
    double currentValue = controller.seekPos > 0
        ? controller.seekPos
        : controller.currentPos.value.inMilliseconds.toDouble();
    currentValue = currentValue.clamp(0, duration < 1 ? 1 : duration);
    double cacheValue =
        controller.bufferPos.value.inMilliseconds.toDouble().clamp(0, duration < 1 ? 1 : duration);

    if (duration <= 0) {
      return _buildStaticSlider();
    }

    return NewFijkSlider(
      colors: NewFijkSliderColors(
        cursorColor: Themes.primaryPurple,
        playedColor: Themes.primaryPurple,
        bufferedColor: Themes.primaryPurple.withOpacity(0.3),
        backgroundColor: Get.isDarkMode
            ? const Color(0xFF2A2A4A)
            : const Color(0xFFDDDDFF),
      ),
      value: currentValue,
      cacheValue: cacheValue,
      min: 0.0,
      max: duration <= 0 ? 1 : duration,
      onChanged: (v) => controller.seekPos = v,
      onChangeEnd: (v) {
        if (controller.seekPos.toInt() == -1) return;
        controller.player.seekTo(v.toInt());
        controller.currentPos.value =
            Duration(milliseconds: controller.seekPos.toInt());
        controller.seekPos = -1;
      },
    );
  }

  Widget _buildStaticSlider() {
    return NewFijkSlider(
      colors: NewFijkSliderColors(
        cursorColor: Themes.primaryPurple,
        playedColor: Themes.primaryPurple,
        backgroundColor: Get.isDarkMode
            ? const Color(0xFF2A2A4A)
            : const Color(0xFFDDDDFF),
      ),
      value: 0,
      onChanged: (_) {},
      onChangeEnd: (_) {},
    );
  }

  /// 时间显示
  Widget _buildTimeRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CommonUtils.isPad ? 4 : 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                FijkHelper.formatDuration(controller.currentPos.value),
                style: TextStyle(
                  color: Get.isDarkMode
                      ? const Color(0xFF7070A0)
                      : const Color(0xFF9999BB),
                  fontSize: CommonUtils.isPad ? 12 : 24.sp,
                ),
              )),
          Obx(() => Text(
                FijkHelper.formatDuration(controller.duration.value),
                style: TextStyle(
                  color: Get.isDarkMode
                      ? const Color(0xFF7070A0)
                      : const Color(0xFF9999BB),
                  fontSize: CommonUtils.isPad ? 12 : 24.sp,
                ),
              )),
        ],
      ),
    );
  }

  /// 主控制按钮区
  Widget _buildControls() {
    final isDark = Get.isDarkMode;
    final mainBtnSize = CommonUtils.isPad ? 64.0 : 130.r;
    final subBtnSize = CommonUtils.isPad ? 44.0 : 90.r;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 上一首
        _CircleIconButton(
          icon: Icons.skip_previous_rounded,
          size: subBtnSize,
          iconSize: CommonUtils.isPad ? 24.0 : 48.sp,
          onTap: () {
            final ct = controller;
            if (ct.playMode.value == PlayMode.SHUFFLE) {
              ct.changePlaylist(Random().nextInt(ct.objects.length));
              return;
            }
            ct.currentIndex.value == 0
                ? ct.changePlaylist(ct.objects.length - 1)
                : ct.changePlaylist(ct.currentIndex.value - 1);
          },
        ),

        // 播放/暂停（大按钮，渐变背景）
        Obx(() => GestureDetector(
              onTap: () => controller.isPlaying.value
                  ? controller.player.pause()
                  : controller.player.start(),
              child: Container(
                width: mainBtnSize,
                height: mainBtnSize,
                decoration: BoxDecoration(
                  gradient: Themes.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Themes.primaryPurple.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: CommonUtils.isPad ? 34.0 : 68.sp,
                ),
              ),
            )),

        // 下一首
        _CircleIconButton(
          icon: Icons.skip_next_rounded,
          size: subBtnSize,
          iconSize: CommonUtils.isPad ? 24.0 : 48.sp,
          onTap: () {
            final ct = controller;
            if (ct.playMode.value == PlayMode.SHUFFLE) {
              ct.changePlaylist(Random().nextInt(ct.objects.length));
              return;
            }
            ct.currentIndex.value == ct.objects.length - 1
                ? ct.changePlaylist(0)
                : ct.changePlaylist(ct.currentIndex.value + 1);
          },
        ),
      ],
    );
  }

  /// 底部功能栏（循环模式 / 播放列表 / 定时）
  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 循环模式
        Obx(() => _SmallIconButton(
              icon: PlayMode.getIcon(controller.playMode.value),
              isActive: controller.playMode.value != PlayMode.LIST_LOOP,
              onTap: () {
                controller.playMode.value =
                    controller.playMode.value == PlayMode.SHUFFLE
                        ? PlayMode.LIST_LOOP
                        : controller.playMode.value + 1;
              },
            )),

        // 播放列表
        Obx(() => _SmallIconButton(
              icon: Icons.queue_music_rounded,
              isActive: controller.isPlaylist.value,
              onTap: () {
                controller.isPlaylist.value = !controller.isPlaylist.value;
                controller.tabController.index =
                    controller.isPlaylist.value ? 1 : 0;
              },
            )),

        // 定时关闭
        Obx(() => _SmallIconButton(
              icon: Icons.timer_outlined,
              isActive: controller.timerDuration.value.inSeconds > 0,
              onTap: () => controller.timedShutdown(),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final coverSize = CommonUtils.isPad
        ? MediaQuery.of(context).size.width * 0.42
        : MediaQuery.of(context).size.width * 0.68;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF13131F) : const Color(0xFFF8F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // ——— 顶栏 ———
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 16 : 40.w,
                vertical: CommonUtils.isPad ? 12 : 24.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    onTap: () => Get.back(),
                  ),
                  Text(
                    'audio_player'.tr,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFD0D0F0)
                          : const Color(0xFF1A1A2E),
                      fontSize: CommonUtils.isPad ? 16 : 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildMenuButton(),
                ],
              ),
            ),

            // ——— 主内容（单曲 / 播放列表 tab） ———
            Expanded(
              child: Obx(() => TabBarView(
                    controller: controller.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildSingleView(coverSize),
                      _buildPlaylistView(coverSize),
                    ],
                  )),
            ),

            // ——— 进度区域 ———
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 24 : 56.w,
              ),
              child: Column(
                children: [
                  Obx(() => _buildSlider()),
                  SizedBox(height: 4.h),
                  _buildTimeRow(),
                ],
              ),
            ),

            SizedBox(height: CommonUtils.isPad ? 20 : 40.h),

            // ——— 主控按钮 ———
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 24 : 56.w,
              ),
              child: _buildControls(),
            ),

            SizedBox(height: CommonUtils.isPad ? 16 : 36.h),

            // ——— 底部功能栏 ———
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 32 : 80.w,
              ),
              child: _buildBottomBar(),
            ),
            SizedBox(height: CommonUtils.isPad ? 16 : 32.h),
          ],
        ),
      ),
    );
  }
}

// ——————————————————————————————
// 辅助 Widget：圆形图标按钮
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  final double? iconSize;
  final bool isLight;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size,
    this.iconSize,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final s = size ?? (CommonUtils.isPad ? 40.0 : 80.r);
    final is_ = iconSize ?? (CommonUtils.isPad ? 20.0 : 42.sp);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252535)
              : (isLight
                  ? Colors.white.withOpacity(0.15)
                  : const Color(0xFFEEEEFF)),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDark ? const Color(0xFFD0D0F0) : const Color(0xFF2A2A3E),
          size: is_,
        ),
      ),
    );
  }
}

// 辅助 Widget：小图标按钮（带激活态颜色）
class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _SmallIconButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Themes.primaryPurple
        : (Get.isDarkMode ? const Color(0xFF6060A0) : const Color(0xFFAAAAAA));
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(CommonUtils.isPad ? 8 : 16.r),
        child: Icon(icon, color: color, size: CommonUtils.isPad ? 24 : 48.sp),
      ),
    );
  }
}
