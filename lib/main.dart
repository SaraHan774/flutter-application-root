import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'firebase_options.dart';
import 'core/core.dart';
import 'shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 로컬 개발 환경에서만 .env 로드 (웹이든 모바일이든)
  if (!kReleaseMode) {
    try {
      await dotenv.load(fileName: ".env");
      print("Local development: .env file loaded successfully");
    } catch (e) {
      print("Failed to load .env file: $e");
    }
  } else {
    print("Production environment: using firebase_options.dart");
  }

  // Firebase 초기화 (firebase_options.dart 사용)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: '한담',
      debugShowCheckedModeBanner: false,
      theme: HandamAppTheme.lightTheme,
      darkTheme: HandamAppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
