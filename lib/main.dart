import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app_project_joseongwoo/screens/home_screen.dart';
import 'constants/colors.dart';
import 'models/memo_model.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 바인딩

  await Hive.initFlutter(); // Hive 초기화 (Flutter에 맞게)

  // 어댑터 등록 (Hive는 커스텀 클래스 저장을 위해 어댑터가 필요함)
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(MemoModelAdapter());

  await Hive.openBox<MemoModel>('memos'); // 로컬 데이터 저장소 열기

  runApp(const ProviderScope(child: MyApp())); // Riverpod 상태관리 적용
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 700), // 기준 해상도 (디자인 기준에 맞춰 변환)
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GC녹십자 앱 개발 과제',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue01),
          scaffoldBackgroundColor: Colors.white, // 배경색
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // 앱바 배경색
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
