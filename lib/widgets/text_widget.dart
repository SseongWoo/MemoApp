import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app_project_joseongwoo/constants/colors.dart';

/// 경고문 위젯
Widget precautions(String content) {
  return Container(
    color: AppColors.grey05,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      child: Text(content, style: TextStyle(fontSize: 14.sp, color: AppColors.grey02)),
    ),
  );
}
