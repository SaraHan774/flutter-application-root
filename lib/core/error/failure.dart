/// 앱 전체에서 사용하는 에러 처리 시스템
/// Clean Architecture 패턴에 따라 도메인 레이어에서 사용할 에러 클래스들

/// 기본 실패 클래스 - 모든 에러의 부모 클래스
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure: $message';
}

/// 네트워크 관련 에러
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// 인증 관련 에러
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Firestore 데이터베이스 관련 에러
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

/// 입력값 검증 에러
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// 권한 관련 에러
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// 알 수 없는 에러
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}

/// 서버 에러
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// 캐시 관련 에러
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
} 