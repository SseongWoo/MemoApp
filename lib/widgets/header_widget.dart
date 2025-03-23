import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

/// 병원 이름과 위치 정보를 상단에 표시하는 헤더 위젯
Widget buildHeader(double titleSize, double subTitleSize) {
  // 소속
  const String title = '단아치과의원단아치과의원아인이이';
  // 병원 위치
  const String location = '서울 구로구 구로 1동';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.add_location, color: AppColors.blue01), // 위치 아이콘
          SizedBox(width: 6.w),

          // 병원명 텍스트
          Expanded(
            child: Text(
              title,
              maxLines: 1, // 한 줄만 표시
              overflow: TextOverflow.ellipsis, // 길면 ... 처리
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppColors.grey01,
              ),
            ),
          ),
        ],
      ),

      // 병원 위치 텍스트
      Padding(
        padding: EdgeInsets.only(left: 36.w),
        child: Text(location, style: TextStyle(fontSize: subTitleSize, color: AppColors.grey03)),
      ),
    ],
  );
}
