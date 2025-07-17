import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'failure.dart';

/// Firebase 에러를 앱의 Failure 클래스로 변환하는 핸들러
class ErrorHandler {
  /// Firebase Auth 에러를 AuthFailure로 변환
  static AuthFailure handleAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthFailure('사용자를 찾을 수 없습니다.');
      case 'wrong-password':
        return const AuthFailure('잘못된 비밀번호입니다.');
      case 'email-already-in-use':
        return const AuthFailure('이미 사용 중인 이메일입니다.');
      case 'weak-password':
        return const AuthFailure('비밀번호가 너무 약합니다.');
      case 'invalid-email':
        return const AuthFailure('유효하지 않은 이메일 형식입니다.');
      case 'operation-not-allowed':
        return const AuthFailure('허용되지 않은 작업입니다.');
      case 'too-many-requests':
        return const AuthFailure('너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.');
      case 'network-request-failed':
        return const AuthFailure('네트워크 연결을 확인해주세요.');
      case 'invalid-verification-code':
        return const AuthFailure('인증번호가 올바르지 않습니다.');
      case 'invalid-verification-id':
        return const AuthFailure('인증 세션이 만료되었습니다. 다시 시도해주세요.');
      case 'session-expired':
        return const AuthFailure('인증 세션이 만료되었습니다.');
      case 'quota-exceeded':
        return const AuthFailure('일일 인증 횟수를 초과했습니다.');
      default:
        return AuthFailure('인증 오류가 발생했습니다: ${exception.message}');
    }
  }

  /// Firestore 에러를 DatabaseFailure로 변환
  static DatabaseFailure handleFirestoreError(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return const DatabaseFailure('데이터 접근 권한이 없습니다.');
      case 'unavailable':
        return const DatabaseFailure('서비스가 일시적으로 사용할 수 없습니다.');
      case 'not-found':
        return const DatabaseFailure('요청한 데이터를 찾을 수 없습니다.');
      case 'already-exists':
        return const DatabaseFailure('이미 존재하는 데이터입니다.');
      case 'resource-exhausted':
        return const DatabaseFailure('리소스가 부족합니다.');
      case 'failed-precondition':
        return const DatabaseFailure('작업을 수행할 수 없는 상태입니다.');
      case 'aborted':
        return const DatabaseFailure('작업이 중단되었습니다.');
      case 'out-of-range':
        return const DatabaseFailure('범위를 벗어난 요청입니다.');
      case 'unimplemented':
        return const DatabaseFailure('구현되지 않은 기능입니다.');
      case 'internal':
        return const DatabaseFailure('내부 서버 오류가 발생했습니다.');
      case 'data-loss':
        return const DatabaseFailure('데이터 손실이 발생했습니다.');
      case 'unauthenticated':
        return const DatabaseFailure('인증이 필요합니다.');
      default:
        return DatabaseFailure('데이터베이스 오류가 발생했습니다: ${exception.message}');
    }
  }

  /// 일반적인 Exception을 UnknownFailure로 변환
  static UnknownFailure handleGenericError(Exception exception) {
    return UnknownFailure('예상치 못한 오류가 발생했습니다: ${exception.toString()}');
  }

  /// 네트워크 에러 처리
  static NetworkFailure handleNetworkError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return const NetworkFailure('인터넷 연결을 확인해주세요.');
    } else if (error.toString().contains('TimeoutException')) {
      return const NetworkFailure('요청 시간이 초과되었습니다.');
    } else {
      return NetworkFailure('네트워크 오류가 발생했습니다: ${error.toString()}');
    }
  }
} 