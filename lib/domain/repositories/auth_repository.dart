import '../entities/user_entity.dart';

/// 인증 관련 Repository 인터페이스
abstract class AuthRepository {
  /// 전화번호 인증 시작 (SMS 전송)
  Future<String> sendPhoneVerificationCode(String phoneNumber);

  /// 인증번호(OTP) 확인 및 로그인
  Future<UserEntity> verifyPhoneCode({required String phoneNumber, required String smsCode, required String verificationId});

  /// 로그아웃
  Future<void> signOut();

  /// 현재 로그인된 유저 반환 (없으면 null)
  Future<UserEntity?> getCurrentUser();
} 