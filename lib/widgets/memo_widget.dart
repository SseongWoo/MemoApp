import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/memo_model.dart';
import '../constants/colors.dart';
import '../utils/date_utils.dart';
import 'custom_dialog.dart';
import 'header_widget.dart';

/// 메모와 그 메모의 답글들을 포함한 메모 위젯
class MemoGroupWidget extends StatelessWidget {
  final MemoModel memo;
  // 메모 삭제 콜백 (uid로 삭제)
  final Function(String uid) onDelete;
  // 메모 수정 콜백
  final Function(String writerUid, String memoUid, String content) onUpdate;
  // 답글 생성 콜백
  final Function(String parentUid, String content) onReply;
  // 답글 수정 콜백
  final Function(String writerUid, String parentUid, String replyUid, String newContent)
  onUpdateReply;
  // 답글 삭제 콜백
  final Function(String writerUid, String parentUid, String replyUid) onDeleteReply;

  const MemoGroupWidget({
    super.key,
    required this.memo,
    required this.onDelete,
    required this.onUpdate,
    required this.onReply,
    required this.onUpdateReply,
    required this.onDeleteReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메인 메모 위젯
          MemoWidget(
            memo: memo,
            isReply: false,
            onDelete:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => ChoiceDialog(
                        title: '메모 삭제하기',
                        contentText: '메모를 삭제하시겠습니까?',
                        onConfirm: () => onDelete(memo.uid),
                      ),
                ),
            onUpdate: () {
              showDialog(
                context: context,
                builder:
                    (_) => InputDialog(
                      title: '메모 수정하기',
                      contentText: memo.content,
                      onConfirm: (text) => onUpdate(memo.writerData.uid, memo.uid, text),
                      titleWidget: buildHeader(16.sp, 12.sp),
                    ),
              );
            },
            onReply: () {
              // 답글 작성 다이얼로그 띄우기
              MemoModel copyMemo = memo.copyMemo(locked: false, myComment: false);
              showDialog(
                context: context,
                builder:
                    (_) => InputDialog(
                      title: '답글 작성하기',
                      hintText:
                          '답글 내용을 작성해주세요.\n거래처 관련자에 대한 내밀 또는 개인 정보 등 입력 시 명예훼손 문제가 발생될 수 있으니 꼭! 유의하세요!',
                      onConfirm: (text) => onReply(memo.uid, text),
                      titleWidget: MemoWidget(memo: copyMemo, isReply: true, replyDialog: true),
                    ),
              );
            },
          ),

          // 답글 목록
          ...memo.reply.map((reply) {
            return MemoWidget(
              memo: reply,
              isReply: true,
              onDelete: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => ChoiceDialog(
                        title: '답글 삭제하기',
                        contentText: '답글을 삭제하시겠습니까?',
                        onConfirm: () => onDeleteReply(reply.writerData.uid, memo.uid, reply.uid),
                      ),
                );
              },
              onUpdate: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => InputDialog(
                        title: '답글 수정하기',
                        contentText: reply.content,
                        onConfirm:
                            (text) =>
                                onUpdateReply(reply.writerData.uid, memo.uid, reply.uid, text),
                        titleWidget: buildHeader(16.sp, 12.sp),
                      ),
                );
              },
            );
          }).toList(),

          // 구분선
          const Divider(height: 0),
        ],
      ),
    );
  }
}

/// 메모 또는 답글을 출력하는 공통 위젯
class MemoWidget extends StatelessWidget {
  final MemoModel memo;
  final bool isReply; // 답글 여부
  final VoidCallback? onReply; // 답글 쓰기 콜백
  final VoidCallback? onDelete; // 삭제 콜백
  final VoidCallback? onUpdate; // 수정 콜백
  final bool? replyDialog; // 답글 다이얼로그 내 포함 여부

  const MemoWidget({
    super.key,
    required this.memo,
    required this.isReply,
    this.onReply,
    this.onDelete,
    this.onUpdate,
    this.replyDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 답글인 경우 화살표 표시
        Row(
          children: [
            if (isReply && replyDialog != true)
              Icon(Icons.subdirectory_arrow_right, size: 30.r, color: Colors.grey),
            if (isReply && replyDialog != true) SizedBox(width: 7.w),

            // 메모 본문
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자, 잠금 아이콘, 수정/삭제 버튼
                  Row(
                    children: [
                      // 프로필 이미지
                      Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: const BoxDecoration(
                          color: AppColors.grey04,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(memo.writerData.profileUrl),
                      ),
                      SizedBox(width: 6.w),

                      // 작성자 정보 및 액션
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 작성자 이름 및 소속
                            Row(
                              children: [
                                Text(
                                  '${memo.writerData.name} | ${memo.writerData.location}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey01,
                                  ),
                                ),
                                if (memo.locked)
                                  Icon(Icons.lock_outline, size: 17.r, color: AppColors.grey01),
                                const Spacer(),

                                // 작성자 본인일 경우만 수정/삭제 노출
                                if (memo.myComment)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: onUpdate,
                                        child: Text(
                                          '수정',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.grey03,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        '|',
                                        style: TextStyle(fontSize: 12.sp, color: AppColors.grey03),
                                      ),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        onTap: onDelete,
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.grey03,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),

                            // 작성 시간
                            Text(
                              formatDateTime(memo.time),
                              style: TextStyle(fontSize: 12.sp, color: AppColors.grey03),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 메모 내용
                  SizedBox(height: 6.h),
                  Text(memo.content, style: TextStyle(fontSize: 14.sp, color: AppColors.grey01)),

                  // 답글 버튼 (부모 메모일 때만 표시)
                  if (!isReply && replyDialog != true)
                    GestureDetector(
                      onTap: onReply,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '답글 쓰기',
                          style: TextStyle(fontSize: 12.sp, color: AppColors.grey03),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // 답글이 아닌 메모 위젯일경우 간격 생성
        if (replyDialog != true) SizedBox(height: 15.h),
      ],
    );
  }
}
