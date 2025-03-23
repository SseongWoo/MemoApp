import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/memo_provider.dart';
import '../widgets/floating_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/memo_widget.dart';
import '../constants/colors.dart';
import '../widgets/text_widget.dart';

/// 메모 화면 - 메모 및 답글 목록을 보여주고 작성하는 화면
class MemoScreen extends ConsumerWidget {
  const MemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(memoProvider); // 메모 리스트
    final notifier = ref.read(memoProvider.notifier); // 상태 변경을 위한 notifier

    return Scaffold(
      // 플로팅 버튼
      floatingActionButton: faButton(
        context,
        buildHeader(16.sp, 12.sp),
        title: '메모 작성하기',
        hintText:
            '기록하고 싶은 영업 내용을 글로 남겨보세요. 거래처 관련자에 대한 내밀 또는 개인 정보 등 입력 시 명예훼손 문제가 발생될 수 있으니 꼭! 유의하세요!',
        buttonLabel: '메모 작성하기',
        onConfirm: (text) => notifier.createMemo(text),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 18.h),
              // 경고 문구 박스
              Container(
                color: AppColors.grey05,
                child: precautions(
                  '거래처 관련자에 대한 내밀 또는 개인 정보 등\n'
                  '명예훼손 문제가 발생될 수 있으니 꼭! 유의하여 작성해 주세요!',
                ),
              ),
              SizedBox(height: 18.h),
              // 총 메모 개수 출력
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '총 ${memos.length}개',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey01),
                ),
              ),

              // 메모 목록
              ListView.builder(
                shrinkWrap: true, // 내부 스크롤 제한
                physics: const NeverScrollableScrollPhysics(), // 외부 스크롤 사용
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  final memo = memos[index];
                  return MemoGroupWidget(
                    memo: memo,
                    // 메모 삭제
                    onDelete: (uid) => notifier.deleteMemo(memo.writerData.uid, uid),
                    // 메모 수정
                    onUpdate: notifier.updateMemo,
                    // 답글 생성
                    onReply: (parentUid, content) => notifier.createReply(parentUid, content),
                    // 답글 삭제
                    onDeleteReply:
                        (writerUid, parentUid, replyUid) =>
                            notifier.deleteReply(writerUid, parentUid, replyUid),
                    // 답글 수정
                    onUpdateReply:
                        (writerUid, parentUid, replyUid, newContent) =>
                            notifier.updateReply(writerUid, parentUid, replyUid, newContent),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
