import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _defaultProjectId = 'handam-app';
  static const String _defaultAuthDomain = 'handam-app.firebaseapp.com';
  static const String _defaultDatabaseUrl = 'https://handam-app.firebaseio.com';
  static const String _defaultStorageBucket = 'handam-app.appspot.com';
  static const String _defaultMessagingSenderId = '123456789';
  static const String _defaultAppId = '1:123456789:android:abcdef123456';

  // Firebase Configuration
  static String get firebaseProjectId => 
      dotenv.env['FIREBASE_PROJECT_ID'] ?? _defaultProjectId;
  
  static String get firebaseApiKey => 
      dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
  
  static String get firebaseAuthDomain => 
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? _defaultAuthDomain;
  
  static String get firestoreDatabaseUrl => 
      dotenv.env['FIRESTORE_DATABASE_URL'] ?? _defaultDatabaseUrl;
  
  static String get firebaseStorageBucket => 
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? _defaultStorageBucket;
  
  static String get firebaseMessagingSenderId => 
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? _defaultMessagingSenderId;
  
  static String get firebaseAppId => 
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? _defaultAppId;

  // App Configuration
  static String get appName => 
      dotenv.env['APP_NAME'] ?? '한담';
  
  static String get appVersion => 
      dotenv.env['APP_VERSION'] ?? '1.0.0';

  // Environment check
  static bool get isDevelopment => 
      dotenv.env['FLUTTER_ENV'] == 'development' || 
      dotenv.env['FLUTTER_ENV'] == null;
  
  static bool get isProduction => 
      dotenv.env['FLUTTER_ENV'] == 'production';

  // Validation
  static bool get isFirebaseConfigured => 
      firebaseApiKey.isNotEmpty && 
      firebaseProjectId.isNotEmpty;
} 