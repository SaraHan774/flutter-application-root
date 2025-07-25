import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/env_config.dart';
import 'core/core.dart';
import 'shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경 변수 로드 (웹에서는 환경 변수 직접 사용)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // 웹 환경에서는 환경 변수가 이미 설정되어 있음
    print("Web environment detected, using environment variables directly");
  }
  
  // Firebase 초기화 (EnvConfig 사용)
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: EnvConfig.firebaseApiKey,
      appId: EnvConfig.firebaseAppId,
      messagingSenderId: EnvConfig.firebaseMessagingSenderId,
      projectId: EnvConfig.firebaseProjectId,
      authDomain: EnvConfig.firebaseAuthDomain,
      storageBucket: EnvConfig.firebaseStorageBucket,
    ),
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
