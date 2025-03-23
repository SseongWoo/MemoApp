import 'package:hive/hive.dart';
part 'user_model.g.dart';

// 유저 모델 클래스
@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String uid; // 유저 고유 id
  @HiveField(1)
  final String name; // 유저 이름
  @HiveField(2)
  final String location; // 유저 소속
  @HiveField(3)
  final String profileUrl; // 유저 프로필 이미지 URL

  UserModel({
    required this.uid,
    required this.name,
    required this.location,
    required this.profileUrl,
  });
}
