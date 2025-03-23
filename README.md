# 메모 앱 과제 프로젝트

## 프로젝트 개요

Flutter 기반의 메모 관리 앱입니다.  
작성자는 메모를 작성하고, 본인이 작성한 메모와 답글에 대해 수정 및 삭제가 가능합니다.
로컬 데이터베이스 Hive를 활용한 로컬 저장이 가능하혀, Riverpod을 통해 상태를 효율적으로 관리합니다.

## 개발 환경

| 항목 | 내용 |
|------|------|
| **프레임워크** | Flutter |
| **언어** | Dart |
| **IDE** | Android Studio |
| **로컬 DB** | Hive |
| **상태 관리** | Riverpod |


## 과제 요구사항
- 로컬 데이터베이스를 활용하여 데이터를 저장 및 관리할 수 있도록 구현해 주세요.
- 메모 및 댓글은 최신 순으로 정렬해 주세요.
- 메모 탭에 CRUD 기능을 적용해 주세요.

## 주요 기능
- 메모 작성, 수정, 삭제 (자신의 메모만 가능)
- 메모에 대한 답글 작성, 수정, 삭제 (자신의 답글만 가능)
- 메모 및 답글 모두 최신순 정렬
- Riverpod을 통한 상태 관리
- Hive 기반의 로컬 저장소 적용

## 모델 구조

유저 데이터 구조
```sh
class UserModel {
  final String uid;          // 사용자 고유 ID
  final String name;         // 사용자 이름
  final String location;     // 소속
  final String profileUrl;   // 프로필 이미지 경로
}
```

메모 데이터 구조
```sh
class MemoModel {
  final String uid;                 // 메모 고유 ID
  final String content;             // 메모 내용
  final DateTime time;              // 작성 시간
  final bool myComment;             // 현재 사용자가 작성자인지 여부
  final bool locked;                // 잠금 여부
  final UserModel writerData;       // 작성자 정보
  final List<MemoModel> reply;      // 답글 리스트
}
```

## 사용한 라이브러리

```sh
dependencies:
  flutter_riverpod: ^2.6.1       # 상태관리 라이브러리
  flutter_screenutil: ^5.9.3     # 반응형 UI를 위한 화면 비율 조정
  intl: ^0.20.2                  # 날짜 및 시간 포맷 변환
  uuid: ^4.5.1                   # 고유 ID 생성을 위한 라이브러리
  hive: ^2.0.4                   # NoSQL DB
  hive_flutter: ^1.1.0           # Hive + Flutter 통합

dev_dependencies:
  hive_generator: ^1.1.0         # Hive 어댑터 자동 생성
  build_runner: ^2.0.4           # 코드 생성 명령 실행 도구
```

## 디렉토리 구조
```sh
lib
├── constants                # 앱 전역에서 사용하는 상수 정의
│   └── colors.dart          # 색상 상수 정의
├── main.dart                # 앱의 진입점, Hive 초기화 및 테마 설정
├── models                   # 데이터 모델 정의 (Hive용 어노테이션 포함)
│   ├── memo_model.dart       # 메모 및 답글 모델 클래스
│   ├── memo_model.g.dart     # memo_model의 자동 생성 어댑터
│   ├── user_model.dart       # 사용자(작성자) 모델 클래스
│   └── user_model.g.dart     # user_model의 자동 생성 어댑터
├── providers                # Riverpod 기반 상태 관리
│   └── memo_provider.dart    # 메모 및 답글 상태 관리 로직
├── screens                  # 각 화면 UI 구성
│   ├── home_screen.dart      # 메모/일정 탭을 포함한 메인 화면
│   ├── memo_screen.dart      # 메모 작성 및 리스트 화면
│   └── schedule_screen.dart  # 일정 탭 화면 (샘플)
├── services                 # 로컬 데이터 처리 계층 (Hive 관련 CRUD)
│   └── memo_service.dart     # 메모/답글 관련 Hive CRUD 로직
├── test_data.dart           # 테스트용 유저 데이터 (작성자 식별용)
├── utils                    # 전역 유틸 함수 모음
│   ├── date_utils.dart       # 작성일 포맷팅 함수 (예: 2시간 전)
│   └── uid_utils.dart        # UUID 기반 고유 ID 생성 함수
└── widgets                  # 재사용 가능한 UI 컴포넌트 모음
  ├── button_widget.dart     # 다이얼로그용 버튼 위젯
  ├── custom_dialog.dart     # 입력 및 확인 다이얼로그 위젯
  ├── floating_widget.dart   # 플로팅 액션 버튼 위젯
  ├── header_widget.dart     # 병원명/주소 헤더 위젯
  ├── memo_widget.dart       # 메모 및 답글 표시용 위젯
  └── text_widget.dart       # 경고 문구 등 텍스트 전용 위젯
```

## 📌 주요 코드 설명

### 1. Riverpod 상태관리

StateNotifier를 활용하여 전체 메모 목록을 효율적으로 관리합니다.
특정 메모 또는 답글을 수정할 때, 리스트 전체를 map()을 이용해 순회하며 대상 항목만 교체하고 나머지는 그대로 유지합니다.
```sh
// 메모 수정 로직 예시 (memo_provider.dart)
state = state.map((m) {
  if (m.uid == memoUid) {
    final updated = m.copyMemo(content: newContent);
    memoService.updateMemo(memoUid, updated); // Hive에도 반영
    return updated;
  }
  return m;
}).toList();
```
- state: 전체 메모 리스트 상태
- copyMemo(): 기존 메모를 수정한 복사본 생성
- 불변성을 유지하여 UI 자동 갱신 유도

### 2. Hive 로컬 저장 방식

Hive를 활용해 메모와 답글을 로컬에 저장합니다.
특히 수정/삭제 시, 전체 메모 객체를 교체하는 방식으로 단순화된 구조를 사용합니다.
```sh
// 메모 또는 답글 수정에 사용 (memo_service.dart)
Future<void> updateSingleMemo(MemoModel updatedMemo) async {
  await _box.put(updatedMemo.uid, updatedMemo);
}
```
- 메모 UID 기준으로 해당 데이터를 통째로 갱신
- 메모 내의 답글도 함께 포함되어 있으므로 부모 메모만 저장하면 답글도 반영됨
- 동일 방식으로 메모 생성 시에도 사용 가능

### 3. 최신순 정렬 처리

작성 시간(DateTime)을 기준으로 메모와 답글을 최신순 정렬합니다.
앱 시작 시, 또는 메모 추가 시 자동으로 리스트를 갱신합니다.
```sh
// 메모 최신순 정렬 (memo_provider.dart)
void sortByNewest() {
  final sorted = [...state];
  sorted.sort((a, b) => b.time.compareTo(a.time));
  state = sorted;
}
```
- 답글도 [replyMemo, ...parentMemo.reply] 방식으로 최신이 위로 오도록 처리
- 사용자가 작성한 최근 메모를 상단에서 확인 가능