import 'package:intl/intl.dart';

/// 메모 작성시간이 현재 시간을 기준으로 얼마나 지났는지를 문자열로 반환하는 함수
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now(); // 현재 시간
  final diff = now.difference(dateTime); // 현재 시간과 입력된 시간의 차이 계산
  final date = DateFormat('yyyy.MM.dd').format(dateTime); // 날짜 포맷

  // 1분 미만
  if (diff.inMinutes < 1) return '방금전 ($date)';

  // 1시간 미만
  if (diff.inMinutes < 60) return '${diff.inMinutes}분전 ($date)';

  // 24시간 미만
  if (diff.inHours < 24) return '${diff.inHours}시간전 ($date)';

  // 24시간 이후
  return '${diff.inDays}일전 ($date)';
}
