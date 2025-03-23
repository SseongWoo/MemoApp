import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import 'custom_dialog.dart';

/// 플로팅 액션 버튼 위젯
Widget faButton(
  BuildContext context,
  Widget titleWidget, {
  required String title,
  required String hintText,
  required void Function(String text) onConfirm,
  required String buttonLabel,
}) {
  return SafeArea(
    child: SizedBox(
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // 버튼 모서리 둥글게
          ),
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 15.w),
          backgroundColor: AppColors.blue01,
        ),
        onPressed: () {
          // 버튼 눌렀을시 다이얼로그 생성
          showDialog(
            context: context,
            builder:
                (_) => InputDialog(
                  title: title,
                  hintText: hintText,
                  onConfirm: onConfirm,
                  titleWidget: titleWidget,
                ),
          );
        },
        // 버튼 텍스트
        child: Text(
          buttonLabel,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.white01),
        ),
      ),
    ),
  );
}
