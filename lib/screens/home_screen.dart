import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../widgets/header_widget.dart';
import 'memo_screen.dart';
import 'schedule_screen.dart';

/// 홈 화면 - 상단 헤더와 탭 뷰를 제공하는 메인 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭 개수 (메모, 일정)
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 55.h), // 상단 여백
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 5.h, 25.w, 5.h),
              child: buildHeader(20.sp, 14.sp), // 헤더 위젯 (앱 타이틀 등)
            ),
            _buildTabBar(), // 탭바 (메모 / 일정)
            const Expanded(
              child: TabBarView(
                children: [
                  MemoScreen(), // 메모 탭
                  ScheduleScreen(), // 일정 탭
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 탭바 UI
  Widget _buildTabBar() {
    return TabBar(
      tabs: const [Tab(text: '메모'), Tab(text: '일정')],
      labelColor: AppColors.grey01, // 선택된 탭 텍스트 색
      unselectedLabelColor: AppColors.grey03, // 선택되지 않은 탭 텍스트 색
      indicatorColor: AppColors.grey01, // 선택된 탭 밑줄 색상
      indicatorSize: TabBarIndicatorSize.tab, // 밑줄 너비 설정
      indicatorWeight: 3.h, // 밑줄 두께
      dividerHeight: 3.h, // 탭바 아래 구분선 높이
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), // 탭바 텍스트 스타일 설정
    );
  }
}
