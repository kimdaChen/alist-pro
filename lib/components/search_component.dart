import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:xlist/common/index.dart';
import 'package:xlist/routes/app_pages.dart';
import 'package:xlist/themes.dart';

class SearchComponent extends StatelessWidget {
  final String path;
  final bool inHeader; // 是否在渐变 Header 内（白色风格）
  SearchComponent({
    Key? key,
    required this.path,
    this.inHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    if (inHeader) {
      // 渐变 Header 内的白色半透明搜索框
      return GestureDetector(
        onTap: () =>
            Get.toNamed(Routes.SEARCH, arguments: {'path': path}),
        child: Container(
          height: CommonUtils.isPad ? 44 : 92.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius:
                BorderRadius.circular(CommonUtils.isPad ? 14 : 28.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: CommonUtils.isPad ? 14 : 30.w,
          ),
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

    // 普通页面中的搜索框（跟随主题）
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.SEARCH, arguments: {'path': path}),
      child: Container(
        height: CommonUtils.isPad ? 44 : 92.h,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252535)
              : const Color(0xFFEEEEFF),
          borderRadius:
              BorderRadius.circular(CommonUtils.isPad ? 14 : 28.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.15)
                  : const Color(0xFF6C63FF).withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: CommonUtils.isPad ? 14 : 30.w,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: isDark
                  ? const Color(0xFF7070A0)
                  : const Color(0xFF9999BB),
              size: CommonUtils.isPad ? 20 : 44.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'search'.tr,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF6060A0)
                    : const Color(0xFF9999BB),
                fontSize: CommonUtils.isPad ? 15 : 30.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
