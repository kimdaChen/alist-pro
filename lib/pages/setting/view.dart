import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:xlist/common/index.dart';
import 'package:xlist/storages/index.dart';
import 'package:xlist/routes/app_pages.dart';
import 'package:xlist/pages/setting/index.dart';
import 'package:xlist/pages/homepage/index.dart';
import 'package:xlist/themes.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  // 渐变顶栏
  Widget _buildHeader() {
    final isDark = Get.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? Themes.darkGradient
            : Themes.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Themes.primaryPurple.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: CommonUtils.isPad ? 36 : 72.r,
                  height: CommonUtils.isPad ? 36 : 72.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: CommonUtils.isPad ? 20 : 40.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'setting'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: CommonUtils.isPad ? 22 : 44.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 分组标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: Themes.primaryPurple,
          fontSize: CommonUtils.isPad ? 12 : 24.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // 现代列表项卡片
  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    Color? iconBgColor,
    String? subtitle,
    Widget? trailing,
    Function()? onTap,
    bool showDivider = true,
  }) {
    final isDark = Get.isDarkMode;
    final bg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFEEEEFF);

    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        splashColor: Themes.primaryPurple.withOpacity(0.08),
        highlightColor: Themes.primaryPurple.withOpacity(0.04),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 16 : 32.w,
                vertical: CommonUtils.isPad ? 14 : 28.h,
              ),
              child: Row(
                children: [
                  // 彩色图标容器
                  Container(
                    width: CommonUtils.isPad ? 36 : 72.r,
                    height: CommonUtils.isPad ? 36 : 72.r,
                    decoration: BoxDecoration(
                      color: (iconBgColor ?? iconColor).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(CommonUtils.isPad ? 10 : 20.r),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: CommonUtils.isPad ? 18 : 36.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // 标题+副标题
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFE8E8FF) : const Color(0xFF1A1A2E),
                            fontSize: CommonUtils.isPad ? 15 : 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? const Color(0xFF7070A0) : const Color(0xFF9999BB),
                              fontSize: CommonUtils.isPad ? 12 : 24.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // trailing
                  if (trailing != null)
                    trailing
                  else if (onTap != null)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? const Color(0xFF5050A0) : const Color(0xFFBBBBDD),
                      size: CommonUtils.isPad ? 20 : 40.sp,
                    ),
                ],
              ),
            ),
            if (showDivider)
              Padding(
                padding: EdgeInsets.only(left: CommonUtils.isPad ? 66 : 132.w),
                child: Divider(height: 1.r, color: dividerColor),
              ),
          ],
        ),
      ),
    );
  }

  // 卡片容器
  Widget _buildCard({required List<Widget> children}) {
    final isDark = Get.isDarkMode;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: CommonUtils.isPad ? 16 : 32.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(CommonUtils.isPad ? 16 : 32.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xFF13131F) : const Color(0xFFF8F8FF),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== 通用设置 =====
                  _buildSectionTitle('general'.tr.toUpperCase()),
                  _buildCard(
                    children: [
                      Obx(
                        () => _buildSettingItem(
                          title: 'server'.tr,
                          icon: Icons.cloud_rounded,
                          iconColor: const Color(0xFF4A90E2),
                          subtitle: controller.serverInfo.value.username,
                          onTap: () => Get.toNamed(Routes.SETTING_SERVER),
                        ),
                      ),
                      Obx(
                        () => _buildSettingItem(
                          title: 'setting_theme'.tr,
                          icon: Icons.palette_rounded,
                          iconColor: const Color(0xFF9C27B0),
                          subtitle: controller.themeModeText.value,
                          onTap: () => controller.changeTheme(),
                        ),
                      ),
                      _buildSettingItem(
                        title: 'favorite'.tr,
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFFFF9800),
                        onTap: () => Get.toNamed(Routes.SETTING_FAVORITE),
                      ),
                      _buildSettingItem(
                        title: 'recent'.tr,
                        icon: Icons.history_rounded,
                        iconColor: const Color(0xFF00BCD4),
                        onTap: () => Get.toNamed(Routes.SETTING_RECENT),
                      ),
                      _buildSettingItem(
                        title: 'download_manager'.tr,
                        icon: Icons.download_rounded,
                        iconColor: const Color(0xFF4CAF50),
                        showDivider: false,
                        onTap: () => Get.toNamed(Routes.SETTING_DOWNLOAD),
                      ),
                    ],
                  ),

                  // ===== 预览设置 =====
                  _buildSectionTitle('preview'.tr.toUpperCase()),
                  _buildCard(
                    children: [
                      _buildSettingItem(
                        title: 'document'.tr,
                        icon: Icons.description_rounded,
                        iconColor: const Color(0xFF2196F3),
                        onTap: () => Get.toNamed(Routes.SETTING_PREVIEW_DOCUMENT),
                      ),
                      _buildSettingItem(
                        title: 'image'.tr,
                        icon: Icons.image_rounded,
                        iconColor: const Color(0xFFE91E63),
                        onTap: () => Get.toNamed(Routes.SETTING_PREVIEW_IMAGE),
                      ),
                      _buildSettingItem(
                        title: 'video'.tr,
                        icon: Icons.video_collection_rounded,
                        iconColor: const Color(0xFFFF5722),
                        onTap: () => Get.toNamed(Routes.SETTING_PREVIEW_VIDEO),
                      ),
                      _buildSettingItem(
                        title: 'audio'.tr,
                        icon: Icons.library_music_rounded,
                        iconColor: Themes.primaryPurple,
                        onTap: () => Get.toNamed(Routes.SETTING_PREVIEW_AUDIO),
                      ),
                      _buildSettingItem(
                        title: 'setting_autoplay'.tr,
                        icon: Icons.play_circle_outline_rounded,
                        iconColor: const Color(0xFF4CAF50),
                        trailing: Obx(
                          () => CupertinoSwitch(
                            activeColor: Themes.primaryPurple,
                            value: controller.isAutoPlay.value,
                            onChanged: (value) {
                              controller.isAutoPlay.value = value;
                              Get.find<PreferencesStorage>().isAutoPlay.val = value;
                            },
                          ),
                        ),
                      ),
                      _buildSettingItem(
                        title: 'setting_hardware'.tr,
                        icon: Icons.memory_rounded,
                        iconColor: const Color(0xFF607D8B),
                        trailing: Obx(
                          () => CupertinoSwitch(
                            activeColor: Themes.primaryPurple,
                            value: controller.isHardwareDecode.value,
                            onChanged: (value) {
                              controller.isHardwareDecode.value = value;
                              Get.find<PreferencesStorage>().isHardwareDecode.val = value;
                            },
                          ),
                        ),
                      ),
                      _buildSettingItem(
                        title: 'setting_preview_image'.tr,
                        icon: Icons.perm_media_rounded,
                        iconColor: const Color(0xFF00BCD4),
                        trailing: Obx(
                          () => CupertinoSwitch(
                            activeColor: Themes.primaryPurple,
                            value: controller.isShowPreview.value,
                            onChanged: (value) {
                              controller.isShowPreview.value = value;
                              Get.find<PreferencesStorage>().isShowPreview.val = value;
                              Get.find<HomepageController>().isShowPreview.value = value;
                            },
                          ),
                        ),
                      ),
                      _buildSettingItem(
                        title: 'setting_background_playback'.tr,
                        icon: Icons.personal_video_rounded,
                        iconColor: const Color(0xFF795548),
                        showDivider: false,
                        trailing: Obx(
                          () => CupertinoSwitch(
                            activeColor: Themes.primaryPurple,
                            value: controller.isBackgroundPlay.value,
                            onChanged: (value) {
                              controller.isBackgroundPlay.value = value;
                              Get.find<PreferencesStorage>().isBackgroundPlay.val = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ===== 其他 =====
                  SizedBox(height: 8.h),
                  _buildCard(
                    children: [
                      _buildSettingItem(
                        title: 'feedback'.tr,
                        icon: Icons.feedback_rounded,
                        iconColor: const Color(0xFFFF9800),
                        onTap: () => launchUrl(
                          Uri.parse(
                            'mailto:hello@gaozihang.com?subject=${'app_name'.tr}, v${controller.version.value}',
                          ),
                        ),
                      ),
                      _buildSettingItem(
                        title: 'setting_review'.tr,
                        icon: Icons.stars_rounded,
                        iconColor: const Color(0xFFFFD700),
                        subtitle: 'setting_review_description'.tr,
                        onTap: () => controller.inAppReview.openStoreListing(
                          appStoreId: '6448833200',
                        ),
                      ),
                      _buildSettingItem(
                        title: 'about'.tr,
                        icon: Icons.info_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        showDivider: false,
                        onTap: () => Get.toNamed(Routes.SETTING_ABOUT),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // 版权信息
                  Center(
                    child: Obx(
                      () => Text(
                        'AList Pro v${controller.version.value}',
                        style: TextStyle(
                          color: Get.isDarkMode
                              ? const Color(0xFF4040A0)
                              : const Color(0xFFBBBBDD),
                          fontSize: CommonUtils.isPad ? 12 : 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
