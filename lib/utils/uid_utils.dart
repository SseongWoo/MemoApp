import 'package:uuid/uuid.dart';

/// Uuid 인스턴스 생성
final uuid = Uuid();

/// 고유한 UID를 생성하여 반환해주는 함수
String createUid() {
  return uuid.v4();
}
