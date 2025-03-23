import 'package:hive/hive.dart';
import '../models/memo_model.dart';

class MemoService {
  static const String _boxName = 'memos';

  Box<MemoModel> get _box => Hive.box<MemoModel>(_boxName);

  /// Hive 박스 열기
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<MemoModel>(_boxName);
    }
  }

  /// 전체 메모 가져오기
  Future<List<MemoModel>> getMemos() async {
    return _box.values.toList();
  }

  /// 메모 추가
  Future<void> createMemo(MemoModel memo) async {
    await _box.put(memo.uid, memo);
  }

  /// 메모 수정, 답글 수정, 답글 삭제
  Future<void> updateMemoModel(MemoModel memo) async {
    await _box.put(memo.uid, memo);
  }

  /// 메모 삭제
  Future<void> deleteMemo(String uid) async {
    await _box.delete(uid);
  }

  /// 답글 추가
  Future<void> createReply(String parentUid, MemoModel replyMemo) async {
    final parentMemo = _box.get(parentUid);
    if (parentMemo != null) {
      final updated = parentMemo.copyMemo(
        reply: [replyMemo, ...parentMemo.reply],
      ); // 최신 답글이 위로 오게 추가
      await _box.put(parentUid, updated);
    }
  }
}
