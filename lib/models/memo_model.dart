import 'package:mobile_app_project_joseongwoo/models/user_model.dart';
import 'package:hive/hive.dart';
part 'memo_model.g.dart';

// 메모 모델 클래스 (Hive 라이브러리를 사용한 로컬 저장 지원)
@HiveType(typeId: 0)
class MemoModel {
  @HiveField(0)
  final String uid; // 메모 고유 id

  @HiveField(1)
  final String content; // 메모 내용

  @HiveField(2)
  final DateTime time; // 메모 작성 시간

  @HiveField(3)
  final bool myComment; // 메모 작성자가 본인여부

  @HiveField(4)
  final bool locked; // 메모 잠금 여부

  @HiveField(5)
  final UserModel writerData; // 메모 작성자 데이터

  @HiveField(6)
  final List<MemoModel> reply; // 답글 데이터

  MemoModel({
    required this.writerData,
    required this.uid,
    required this.content,
    required this.time,
    this.myComment = true,
    this.locked = false,
    required this.reply,
  });

  // 메모 데이터 복사
  MemoModel copyMemo({
    UserModel? writerData,
    String? uid,
    String? content,
    DateTime? time,
    bool? myComment,
    bool? locked,
    List<MemoModel>? reply,
  }) {
    return MemoModel(
      writerData: writerData ?? this.writerData,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      time: time ?? this.time,
      myComment: myComment ?? this.myComment,
      locked: locked ?? this.locked,
      reply: reply ?? this.reply,
    );
  }
}
