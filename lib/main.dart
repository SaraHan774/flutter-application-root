import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'core/core.dart';
import 'shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 웹이 아닌 경우에만 .env 로드
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print("Failed to load .env file: $e");
    }
  } else {
    print("Web environment detected, using firebase_options.dart");
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
