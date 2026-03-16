import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:xlist/common/index.dart';
import 'package:xlist/helper/index.dart';
import 'package:xlist/storages/index.dart';
import 'package:xlist/constants/index.dart';
import 'package:xlist/components/index.dart';
import 'package:xlist/routes/app_pages.dart';
import 'package:xlist/pages/homepage/index.dart';
import 'package:xlist/database/entity/index.dart';
import 'package:xlist/services/browser_service.dart';
import 'package:xlist/themes.dart';

class Homepage extends GetView<HomepageController> {
  const Homepage({Key? key}) : super(key: key);

  /// 顶部渐变装饰区域（品牌色渐变 + 标题 + 操作按钮）
  Widget _buildHeader(BuildContext context) {
    final isDark = Get.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
              )
            : Themes.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Themes.primaryPurple.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶栏：设置 + 操作菜单
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 设置按钮
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.SETTING)
                        ?.then((value) => controller.getObjectList()),
                    child: Container(
                      width: CommonUtils.isPad ? 40 : 80.r,
                      height: CommonUtils.isPad ? 40 : 80.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: CommonUtils.isPad ? 22 : 44.sp,
                      ),
                    ),
                  ),
                  // 操作菜单
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ButtonHelper.createPullDownButton(
                        controller: controller,
                        path: '/',
                        source: PageSource.HOMEPAGE,
                        pageTag: tag ?? '',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // 标题
              Text(
                'homepage_title'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: CommonUtils.isPad ? 28 : 56.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(() {
                final username = controller.userInfo.value.username ?? '';
                if (username.isEmpty) return const SizedBox();
                return Text(
                  username,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: CommonUtils.isPad ? 14 : 28.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              SizedBox(height: 20.h),
              // 搜索栏
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// 现代搜索栏
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.SEARCH, arguments: {'path': '/'}),
      child: Container(
        height: CommonUtils.isPad ? 44 : 96.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(CommonUtils.isPad ? 14 : 28.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: CommonUtils.isPad ? 14 : 30.w),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.8),
              size: CommonUtils.isPad ? 20 : 44.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'search'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: CommonUtils.isPad ? 15 : 30.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 无服务器配置提示
  Widget _buildEmptyServer() {
    final isDark = Get.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 100.h),
      child: Column(
        children: [
          Container(
            width: CommonUtils.isPad ? 120 : 280.r,
            height: CommonUtils.isPad ? 120 : 280.r,
            decoration: BoxDecoration(
              gradient: Themes.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Themes.primaryPurple.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              color: Colors.white,
              size: CommonUtils.isPad ? 60 : 140.sp,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            'homepage_empty_server_title'.tr,
            style: TextStyle(
              color: isDark ? const Color(0xFFD0D0F0) : const Color(0xFF2A2A3E),
              fontSize: CommonUtils.isPad ? 18 : 38.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => BrowserService.to.open('https://alist.nn.ci'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  size: CommonUtils.isPad ? 16 : 36.sp,
                  color: Themes.primaryPurple,
                ),
                SizedBox(width: 6.w),
                Text(
                  'homepage_empty_server_help'.tr,
                  style: TextStyle(
                    color: Themes.primaryPurple,
                    fontSize: CommonUtils.isPad ? 14 : 28.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            decoration: BoxDecoration(
              gradient: Themes.primaryGradient,
              borderRadius: BorderRadius.circular(CommonUtils.isPad ? 14 : 28.r),
              boxShadow: [
                BoxShadow(
                  color: Themes.primaryPurple.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(CommonUtils.isPad ? 14 : 28.r),
                onTap: () async {
                  final result = await BottomSheetHelper.showBottomSheet(
                    AddServerBottomSheet(),
                  );
                  if (result == null) return;
                  if (!(result is ServerEntity)) return;

                  Get.find<UserStorage>().serverId.val = result.id!;
                  Get.find<UserStorage>().serverUrl.val = result.url;

                  controller.serverId.value = result.id!;
                  await controller.resetUserToken(result);
                  controller.getObjectList();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: CommonUtils.isPad ? 28 : 60.w,
                    vertical: CommonUtils.isPad ? 14 : 30.h,
                  ),
                  child: Text(
                    'homepage_empty_server_button'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: CommonUtils.isPad ? 16 : 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 文件列表
  Widget _buildSliverList() {
    if (controller.isFirstLoading.isTrue) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 300.h),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: CommonUtils.isPad ? 40 : 80.r,
                  height: CommonUtils.isPad ? 40 : 80.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Themes.primaryPurple),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'loading...'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? const Color(0xFF7070A0)
                        : const Color(0xFF9999BB),
                    fontSize: CommonUtils.isPad ? 13 : 26.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizeCacheWidget(
      child: controller.layoutType.value == LayoutType.GRID
          ? ObjectGridComponent(
              tag: '',
              source: PageSource.HOMEPAGE,
              userInfo: controller.userInfo.value,
              path: '/',
              objects: controller.objects.value,
              isShowPreview: controller.isShowPreview.value,
            )
          : ObjectListComponent(
              tag: '',
              source: PageSource.HOMEPAGE,
              userInfo: controller.userInfo.value,
              path: '/',
              objects: controller.objects.value,
              isShowPreview: controller.isShowPreview.value,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? const Color(0xFF13131F)
          : const Color(0xFFF8F8FF),
      body: EasyRefresh(
        controller: controller.easyRefreshController,
        header: ClassicHeader(
          position: IndicatorPosition.locator,
          processedDuration: Duration.zero,
          iconTheme: IconThemeData(
            color: Get.isDarkMode ? Colors.white70 : Themes.primaryPurple,
          ),
          textStyle: TextStyle(
            color: Get.isDarkMode
                ? const Color(0xFF7070A0)
                : const Color(0xFF9999BB),
            fontSize: CommonUtils.isPad ? 12 : 24.sp,
          ),
        ),
        onRefresh: () async {
          await HapticFeedback.selectionClick();
          await controller.getObjectList();
          controller.easyRefreshController.finishRefresh();
          controller.easyRefreshController.resetFooter();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // 顶部渐变区域（非 Sliver，包装为 SliverToBoxAdapter）
            SliverToBoxAdapter(child: _buildHeader(context)),
            HeaderLocator.sliver(),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: CommonUtils.isPad ? 16 : 0,
                vertical: CommonUtils.isPad ? 8 : 0,
              ),
              sliver: Obx(
                () => controller.serverId.value == 0 &&
                        controller.isFirstLoading.isFalse
                    ? SliverToBoxAdapter(child: _buildEmptyServer())
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: CommonUtils.isPad ? 4 : 10.r,
                        ),
                        sliver: _buildSliverList(),
                      ),
              ),
            ),
            FooterLocator.sliver(),
            // 底部留白
            SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          ],
        ),
      ),
    );
  }
}
