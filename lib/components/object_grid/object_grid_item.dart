import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:xlist/helper/index.dart';
import 'package:xlist/models/index.dart';
import 'package:xlist/common/index.dart';
import 'package:xlist/constants/index.dart';
import 'package:xlist/themes.dart';

class ObjectGridItem extends StatefulWidget {
  final ObjectModel object;
  final bool isShowPreview;

  const ObjectGridItem({
    Key? key,
    required this.object,
    required this.isShowPreview,
  }) : super(key: key);

  @override
  _ObjectGridItemState createState() => _ObjectGridItemState();
}

class _ObjectGridItemState extends State<ObjectGridItem>
    with AutomaticKeepAliveClientMixin {
  ObjectModel get object => widget.object;

  // 根据文件类型返回渐变色（与 list item 保持一致）
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

  /// 图标区域
  Widget _buildIcon() {
    final iconAreaSize = CommonUtils.isPad ? 72.0 : 150.r;
    final borderRadius = CommonUtils.isPad ? 18.0 : 36.r;

    if (widget.isShowPreview &&
        object.thumb != null &&
        object.thumb!.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: SizedBox(
              width: iconAreaSize,
              height: iconAreaSize,
              child: CachedNetworkImage(
                imageUrl: object.thumb!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getIconGradient(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getIconGradient(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    FileType.getIcon(object.type ?? 0, object.name ?? ''),
                    color: Colors.white,
                    size: iconAreaSize * 0.45,
                  ),
                ),
              ),
            ),
          ),
          if (PreviewHelper.isVideo(object.name ?? ''))
            Positioned(
              bottom: 5.r,
              right: 5.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.play_circle_rounded,
                  color: Colors.white,
                  size: CommonUtils.isPad ? 12 : 26.sp,
                ),
              ),
            ),
        ],
      );
    }

    return Container(
      width: iconAreaSize,
      height: iconAreaSize,
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
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        FileType.getIcon(object.type ?? 0, object.name ?? ''),
        color: Colors.white,
        size: iconAreaSize * 0.45,
      ),
    );
  }

  /// 文件名 + 时间/大小
  Widget _buildInfo() {
    final modified = object.modified == null
        ? ''
        : Jiffy.parseFromDateTime(object.modified!)
            .format(pattern: 'yyyy/MM/dd');
    final isDark = Get.isDarkMode;

    return Column(
      children: [
        Text(
          object.name ?? '',
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? const Color(0xFFE0E0F8) : const Color(0xFF1A1A2E),
            fontSize: CommonUtils.isPad ? 12 : 24.sp,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        if (modified.isNotEmpty) ...[
          SizedBox(height: 3.h),
          Text(
            modified,
            style: TextStyle(
              color: isDark
                  ? const Color(0xFF7070A0)
                  : const Color(0xFF9999BB),
              fontSize: CommonUtils.isPad ? 10 : 20.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: 2.h),
        Text(
          object.isDir! ? '∞' : CommonUtils.formatFileSize(object.size!),
          style: TextStyle(
            color: isDark
                ? const Color(0xFF6060A0)
                : const Color(0xFFAAAAAA),
            fontSize: CommonUtils.isPad ? 10 : 20.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(CommonUtils.isPad ? 16 : 28.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF6C63FF).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(CommonUtils.isPad ? 12 : 24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(height: CommonUtils.isPad ? 10 : 20.h),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
