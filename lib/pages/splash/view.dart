import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:xlist/themes.dart';
import 'package:xlist/pages/splash/index.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF4A90E2),
              Color(0xFF00BCD4),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo 图标
                Container(
                  width: CommonUtils.isPad ? 100 : 200.r,
                  height: CommonUtils.isPad ? 100 : 200.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      CommonUtils.isPad ? 28 : 56.r,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.cloud_rounded,
                    color: Colors.white,
                    size: CommonUtils.isPad ? 54 : 110.sp,
                  ),
                ),
                SizedBox(height: CommonUtils.isPad ? 20 : 40.h),
                // App 名称
                Text(
                  'AList Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: CommonUtils.isPad ? 32 : 64.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: CommonUtils.isPad ? 8 : 16.h),
                Text(
                  'Your Ultimate AList Client',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: CommonUtils.isPad ? 14 : 28.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: CommonUtils.isPad ? 60 : 120.h),
                // 加载指示器
                SizedBox(
                  width: CommonUtils.isPad ? 28 : 56.r,
                  height: CommonUtils.isPad ? 28 : 56.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
