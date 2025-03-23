import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/memo_model.dart';
import '../services/memo_service.dart';
import '../test_data.dart';
import '../utils/uid_utils.dart';

/// 전체 메모 리스트 상태를 관리하는 Provider
final memoProvider = StateNotifierProvider<MemoNotifier, List<MemoModel>>((ref) {
  return MemoNotifier();
});

/// 메모 및 답글의 상태 관리 로직을 담당하는 StateNotifier
class MemoNotifier extends StateNotifier<List<MemoModel>> {
  final memoService = MemoService();

  MemoNotifier() : super([]) {
    loadMemos(); // 앱 시작 시 저장된 메모 불러오기
  }

  /// 메모 최신순 정렬
  void sortByNewest() {
    final sorted = [...state]; // 기존 상태 복사
    sorted.sort((a, b) => b.time.compareTo(a.time)); // 최신순 정렬
    state = sorted;
  }

  /// 로컬 저장소에서 메모 데이터 불러오기
  Future<void> loadMemos() async {
    await memoService.init(); // Hive 초기화
    state = await memoService.getMemos(); // 저장된 메모 불러오기
    sortByNewest(); // 불러온 메모 최신순 정렬
  }

  /// 메모 생성
  Future<void> createMemo(String content) async {
    final memo = MemoModel(
      uid: createUid(), // 고유 ID 생성
      content: content, // 메모 내용
      time: DateTime.now(), // 작성 시간
      writerData: userTestData, // 작성자 정보
      reply: [], // 답글 리스트
    );
    await memoService.createMemo(memo); // 로컬에 저장
    state = [memo, ...state]; // 리스트 갱신
  }

  /// 메모 수정
  Future<void> updateMemo(String writerUid, String memoUid, String newContent) async {
    if (writerUid != userTestData.uid) return; // 작성자 확인

    List<MemoModel> updatedList =
        state.map((memo) {
          if (memo.uid == memoUid) {
            final updatedMemo = memo.copyMemo(content: newContent); // 내용만 수정
            memoService.updateMemoModel(updatedMemo); // Hive에 저장
            return updatedMemo;
          }
          return memo;
        }).toList();

    state = updatedList; // 상태 갱신
  }

  /// 메모 삭제
  Future<void> deleteMemo(String witerUid, String memoUid) async {
    if (witerUid != userTestData.uid) return; // 작성자 확인
    await memoService.deleteMemo(memoUid); // 로컬에 있는 데이터 삭제
    state = state.where((m) => m.uid != memoUid).toList(); // 리스트 갱신
  }

  /// 답글 생성
  Future<void> createReply(String parentUid, String content) async {
    final reply = MemoModel(
      uid: createUid(), // 고유 id 생성
      content: content, // 답글 내용
      time: DateTime.now(), // 작성 시간
      writerData: userTestData, // 작성자 정보
      reply: [],
    );

    await memoService.createReply(parentUid, reply); // 로컬에 저장

    // 리스트 갱신
    state =
        state.map((memo) {
          if (memo.uid == parentUid) {
            final updatedReplies = [reply, ...memo.reply]; // 답글 추가
            return memo.copyMemo(reply: updatedReplies); // 갱신된 메모 반환
          }
          return memo;
        }).toList();
  }

  /// 답글 수정
  Future<void> updateReply(
    String writerUid,
    String parentUid,
    String replyUid,
    String newContent,
  ) async {
    if (writerUid != userTestData.uid) return;

    MemoModel? updatedParent;

    // 상태에서 부모 메모를 찾아 답글 수정
    final updatedList =
        state.map((memo) {
          if (memo.uid == parentUid) {
            final updatedReplies =
                memo.reply.map((r) {
                  if (r.uid == replyUid) {
                    return r.copyMemo(content: newContent); // 수정된 내용 적용
                  }
                  return r;
                }).toList();

            updatedParent = memo.copyMemo(reply: updatedReplies);
            return updatedParent!;
          }
          return memo;
        }).toList();

    // 로컬 DB에 수정된 부모 메모 저장
    if (updatedParent != null) {
      await memoService.updateMemoModel(updatedParent!);
    }

    // 상태 갱신
    state = updatedList;
  }

  /// 답글 삭제
  Future<void> deleteReply(String writerUid, String parentUid, String replyUid) async {
    if (writerUid != userTestData.uid) return;

    MemoModel? updatedMemo;

    // 상태에서 부모 메모를 찾아서 답글 삭제
    final updatedList =
        state.map((memo) {
          if (memo.uid == parentUid) {
            final newReplies = memo.reply.where((r) => r.uid != replyUid).toList();
            updatedMemo = memo.copyMemo(reply: newReplies); // 수정된 내용 적용
            return updatedMemo!;
          }
          return memo;
        }).toList();

    // 로컬 DB에 수정된 부모 메모 저장
    if (updatedMemo != null) {
      await memoService.updateMemoModel(updatedMemo!);
    }

    // 상태 갱신
    state = updatedList;
  }
}
