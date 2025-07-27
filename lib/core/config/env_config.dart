import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EnvConfig {
  static const String _defaultProjectId = 'handam-app';
  static const String _defaultAuthDomain = 'handam-app.firebaseapp.com';
  static const String _defaultDatabaseUrl = 'https://handam-app.firebaseio.com';
  static const String _defaultStorageBucket = 'handam-app.appspot.com';
  static const String _defaultMessagingSenderId = '123456789';
  static const String _defaultAppId = '1:123456789:android:abcdef123456';

  // 환경 변수 읽기 헬퍼 메서드
  static String _getEnv(String key, [String defaultValue = '']) {
    if (kIsWeb) {
      // 웹 환경에서는 String.fromEnvironment 사용
      return const String.fromEnvironment(key, defaultValue: defaultValue);
    } else {
      // 모바일 환경에서는 dotenv 사용
      return dotenv.env[key] ?? defaultValue;
    }
  }

  // Firebase Configuration
  static String get firebaseProjectId => 
      _getEnv('FIREBASE_PROJECT_ID', _defaultProjectId);
  
  static String get firebaseApiKey => 
      _getEnv('FIREBASE_API_KEY_ANDROID', '');
  
  static String get firebaseAuthDomain => 
      _getEnv('FIREBASE_AUTH_DOMAIN', _defaultAuthDomain);
  
  static String get firestoreDatabaseUrl => 
      _getEnv('FIRESTORE_DATABASE_URL', _defaultDatabaseUrl);
  
  static String get firebaseStorageBucket => 
      _getEnv('FIREBASE_STORAGE_BUCKET', _defaultStorageBucket);
  
  static String get firebaseMessagingSenderId => 
      _getEnv('FIREBASE_MESSAGING_SENDER_ID', _defaultMessagingSenderId);
  
  static String get firebaseAppId => 
      _getEnv('FIREBASE_APP_ID_ANDROID', _defaultAppId);

  // App Configuration
  static String get appName => 
      _getEnv('APP_NAME', '한담');
  
  static String get appVersion => 
      _getEnv('APP_VERSION', '1.0.0');

  // Environment check
  static bool get isDevelopment => 
      _getEnv('FLUTTER_ENV', 'development') == 'development' || 
      _getEnv('FLUTTER_ENV', '') == '';
  
  static bool get isProduction => 
      _getEnv('FLUTTER_ENV', '') == 'production';

  // Validation
  static bool get isFirebaseConfigured => 
      firebaseApiKey.isNotEmpty && 
      firebaseProjectId.isNotEmpty;
} 