import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app_project_joseongwoo/constants/colors.dart';

import 'button_widget.dart';

/// 텍스트 입력이 필요한 다이얼로그 (예: 메모 작성, 수정 등)
class InputDialog extends StatefulWidget {
  final String title; // 다이얼로그 상단 제목
  final String? hintText; // 입력 필드 힌트 텍스트
  final String? contentText; // 기존 입력값
  final void Function(String text) onConfirm; // 완료 버튼 클릭 시 호출되는 콜백
  final Widget titleWidget; // 타이틀 위젯

  const InputDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.titleWidget,
    this.hintText,
    this.contentText,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.contentText ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 295.w,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 타이틀 및 닫기 버튼
            Container(
              width: 265.w,
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppColors.grey03,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 24.r, color: const Color(0xffADADAD)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),
            Divider(color: const Color(0xffE4E4E4), height: 0),
            SizedBox(height: 10.h),

            // 타이틀 위젯
            SizedBox(
              width: 265.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: widget.titleWidget,
              ),
            ),

            SizedBox(height: 10.h),

            // 입력 필드
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: AppColors.grey04),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              child: SizedBox(
                width: 240.w,
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.grey03),
                  ),
                  cursorColor: AppColors.blue01,
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // 하단 버튼 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dialogButton(
                  '취소',
                  AppColors.grey03,
                  AppColors.grey05,
                  () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 9.w),
                dialogButton('완료', AppColors.white01, AppColors.blue01, () {
                  widget.onConfirm(_controller.text); // 입력값 전달
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 확인만 필요한 다이얼로그 (예: 삭제 확인 등)
class ChoiceDialog extends StatelessWidget {
  final String title; // 다이얼로그 상단 제목
  final String contentText; // 본문 설명 텍스트
  final VoidCallback onConfirm; // '완료' 버튼 클릭 시 콜백

  const ChoiceDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.contentText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 295.w,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 타이틀 및 닫기 버튼
            Container(
              width: 265.w,
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppColors.grey03,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 24.r, color: const Color(0xffADADAD)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Divider(color: const Color(0xffE4E4E4), height: 0),
            SizedBox(height: 10.h),

            // 본문 설명
            Text(contentText, style: TextStyle(fontSize: 14.sp)),

            SizedBox(height: 30.h),

            // 버튼 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dialogButton(
                  '취소',
                  AppColors.grey03,
                  AppColors.grey05,
                  () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 9.w),
                dialogButton('완료', AppColors.white01, AppColors.blue01, () {
                  onConfirm(); // 확인 콜백 실행
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
