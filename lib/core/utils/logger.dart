import 'package:flutter/foundation.dart';

/// 앱의 로깅 시스템
/// 개발/디버그/릴리즈 모드에 따라 다른 로깅 레벨 적용
class AppLogger {
  static const String _tag = '[한담]';
  
  /// 디버그 로그 (개발 모드에서만 출력)
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_tag [DEBUG] $message');
      if (error != null) {
        print('$_tag [DEBUG] Error: $error');
      }
      if (stackTrace != null) {
        print('$_tag [DEBUG] StackTrace: $stackTrace');
      }
    }
  }

  /// 정보 로그
  static void info(String message) {
    if (kDebugMode) {
      print('$_tag [INFO] $message');
    }
  }

  /// 경고 로그
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    print('$_tag [WARNING] $message');
    if (error != null) {
      print('$_tag [WARNING] Error: $error');
    }
    if (stackTrace != null) {
      print('$_tag [WARNING] StackTrace: $stackTrace');
    }
  }

  /// 에러 로그
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('$_tag [ERROR] $message');
    if (error != null) {
      print('$_tag [ERROR] Error: $error');
    }
    if (stackTrace != null) {
      print('$_tag [ERROR] StackTrace: $stackTrace');
    }
    
    // TODO: Firebase Crashlytics 연동 시 여기에 에러 보고 추가
    // FirebaseCrashlytics.instance.recordError(error ?? message, stackTrace);
  }

  /// 성능 측정 로그
  static void performance(String operation, Duration duration) {
    if (kDebugMode) {
      print('$_tag [PERFORMANCE] $operation: ${duration.inMilliseconds}ms');
    }
  }

  /// 네트워크 요청 로그
  static void network(String method, String url, {int? statusCode, String? response}) {
    if (kDebugMode) {
      print('$_tag [NETWORK] $method $url');
      if (statusCode != null) {
        print('$_tag [NETWORK] Status: $statusCode');
      }
      if (response != null) {
        print('$_tag [NETWORK] Response: $response');
      }
    }
  }

  /// 사용자 액션 로그
  static void userAction(String action, {Map<String, dynamic>? parameters}) {
    if (kDebugMode) {
      print('$_tag [USER_ACTION] $action');
      if (parameters != null) {
        print('$_tag [USER_ACTION] Parameters: $parameters');
      }
    }
    
    // TODO: Firebase Analytics 연동 시 여기에 이벤트 전송 추가
    // FirebaseAnalytics.instance.logEvent(name: action, parameters: parameters);
  }

  /// 인증 관련 로그
  static void auth(String action, {String? userId, String? error}) {
    if (kDebugMode) {
      print('$_tag [AUTH] $action');
      if (userId != null) {
        print('$_tag [AUTH] User ID: $userId');
      }
      if (error != null) {
        print('$_tag [AUTH] Error: $error');
      }
    }
  }

  /// 채팅 관련 로그
  static void chat(String action, {String? chatRoomId, String? message}) {
    if (kDebugMode) {
      print('$_tag [CHAT] $action');
      if (chatRoomId != null) {
        print('$_tag [CHAT] Chat Room ID: $chatRoomId');
      }
      if (message != null) {
        print('$_tag [CHAT] Message: $message');
      }
    }
  }

  /// 매칭 관련 로그
  static void matching(String action, {String? userId, String? matchedUserId}) {
    if (kDebugMode) {
      print('$_tag [MATCHING] $action');
      if (userId != null) {
        print('$_tag [MATCHING] User ID: $userId');
      }
      if (matchedUserId != null) {
        print('$_tag [MATCHING] Matched User ID: $matchedUserId');
      }
    }
  }

  /// 데이터베이스 관련 로그
  static void database(String operation, String collection, {String? documentId, Object? error}) {
    if (kDebugMode) {
      print('$_tag [DATABASE] $operation on $collection');
      if (documentId != null) {
        print('$_tag [DATABASE] Document ID: $documentId');
      }
      if (error != null) {
        print('$_tag [DATABASE] Error: $error');
      }
    }
  }

  /// 앱 생명주기 로그
  static void lifecycle(String state) {
    if (kDebugMode) {
      print('$_tag [LIFECYCLE] $state');
    }
  }

  /// 메모리 사용량 로그
  static void memory(String operation, {int? bytes}) {
    if (kDebugMode) {
      print('$_tag [MEMORY] $operation');
      if (bytes != null) {
        final mb = bytes / (1024 * 1024);
        print('$_tag [MEMORY] Size: ${mb.toStringAsFixed(2)} MB');
      }
    }
  }
} 