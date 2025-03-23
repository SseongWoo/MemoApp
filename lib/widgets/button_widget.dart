import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 다이얼로그에서 사용되는 공통 버튼 위젯
Widget dialogButton(
  String buttonLabel,
  Color textColor,
  Color backgroungColor,
  VoidCallback onPressed,
) {
  return SizedBox(
    height: 36.h,
    width: 128.w,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroungColor, // 배경 색상 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2), // 곡률 설정
        ),
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: textColor),
      ),
    ),
  );
}
