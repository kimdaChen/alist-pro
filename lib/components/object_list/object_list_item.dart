import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:xlist/gen/index.dart';
import 'package:xlist/helper/index.dart';
import 'package:xlist/models/index.dart';
import 'package:xlist/common/index.dart';
import 'package:xlist/constants/index.dart';
import 'package:xlist/themes.dart';

class ObjectListItem extends StatefulWidget {
  final ObjectModel object;
  final bool isShowPreview;

  const ObjectListItem({
    Key? key,
    required this.object,
    required this.isShowPreview,
  }) : super(key: key);

  @override
  _ObjectListItemState createState() => _ObjectListItemState();
}

class _ObjectListItemState extends State<ObjectListItem>
    with AutomaticKeepAliveClientMixin {
  ObjectModel get object => widget.object;

  // 根据文件类型返回渐变色
  List<Color> _getIconGradient() {
    final name = object.name ?? '';
    if (object.isDir == true) {
      return [const Color(0xFF6C63FF), const Color(0xFF4A90E2)];
    }
    if (PreviewHelper.isVideo(name)) {
      return [const Color(0xFFE91E8C), const Color(0xFFFF5722)];
    }
    if (PreviewHelper.isAudio(name)) {
      return [const Color(0xFF00BCD4), const Color(0xFF2196F3)];
    }
    if (PreviewHelper.isImage(name)) {
      return [const Color(0xFF4CAF50), const Color(0xFF8BC34A)];
    }
    if (PreviewHelper.isDocument(name)) {
      return [const Color(0xFFFF9800), const Color(0xFFFFC107)];
    }
    return [const Color(0xFF9E9E9E), const Color(0xFFBDBDBD)];
  }

  /// 构建图标区域
  Widget _buildIcon() {
    final iconSize = CommonUtils.isPad ? 28.0 : 58.sp;
    final containerSize = CommonUtils.isPad ? 52.0 : 112.r;
    final borderRadius = CommonUtils.isPad ? 14.0 : 28.r;

    // 有预览图时显示缩略图
    if (widget.isShowPreview &&
        object.thumb != null &&
        object.thumb!.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: SizedBox(
              width: containerSize,
              height: containerSize,
              child: CachedNetworkImage(
                imageUrl: object.thumb!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getIconGradient(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Center(
                    child: Icon(
                      FileType.getIcon(object.type ?? 0, object.name ?? ''),
                      color: Colors.white.withOpacity(0.7),
                      size: iconSize * 0.7,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getIconGradient(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Icon(
                    FileType.getIcon(object.type ?? 0, object.name ?? ''),
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          // 视频标记
          if (PreviewHelper.isVideo(object.name ?? ''))
            Positioned(
              bottom: 4.r,
              right: 4.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.play_circle_rounded,
                  color: Colors.white,
                  size: CommonUtils.isPad ? 10 : 22.sp,
                ),
              ),
            ),
        ],
      );
    }

    // 无预览图：渐变背景 + 白色图标
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getIconGradient(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getIconGradient().first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        FileType.getIcon(object.type ?? 0, object.name ?? ''),
        color: Colors.white,
        size: iconSize,
      ),
    );
  }

  /// 文件名称 + 时间/大小
  Widget _buildInfo() {
    final modified = object.modified == null
        ? ''
        : Jiffy.parseFromDateTime(object.modified!)
            .format(pattern: 'yyyy/MM/dd');

    final sizeOrInfinity = object.isDir!
        ? '∞'
        : CommonUtils.formatFileSize(object.size!);

    final subtitle = modified.isEmpty
        ? sizeOrInfinity
        : '$modified  ·  $sizeOrInfinity';

    final isDark = Get.isDarkMode;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            object.name ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? const Color(0xFFE8E8FF)
                  : const Color(0xFF1A1A2E),
              fontSize: CommonUtils.isPad ? 15 : 30.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? const Color(0xFF7070A0)
                  : const Color(0xFF9999BB),
              fontSize: CommonUtils.isPad ? 12 : 24.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isDark = Get.isDarkMode;
    final hPad = CommonUtils.isPad ? 16.0 : 32.r;
    final vPad = CommonUtils.isPad ? 8.0 : 18.r;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: CommonUtils.isPad ? 8 : 16.w,
        vertical: CommonUtils.isPad ? 2 : 4.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(CommonUtils.isPad ? 16 : 24.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF6C63FF).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: Row(
          children: [
            _buildIcon(),
            SizedBox(width: CommonUtils.isPad ? 14 : 28.w),
            _buildInfo(),
            if (object.isDir == true)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? const Color(0xFF4040A0)
                      : const Color(0xFFCCCCEE),
                  size: CommonUtils.isPad ? 20 : 44.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
