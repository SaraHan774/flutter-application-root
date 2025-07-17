import '../../repositories/auth_repository.dart';
import '../../entities/user_entity.dart';

/// 인증번호(OTP) 확인 UseCase
class VerifyPhoneCodeUseCase {
  final AuthRepository repository;
  VerifyPhoneCodeUseCase(this.repository);

  /// 인증번호 확인 및 로그인
  Future<UserEntity> call({required String phoneNumber, required String smsCode, required String verificationId}) async {
    return await repository.verifyPhoneCode(phoneNumber: phoneNumber, smsCode: smsCode, verificationId: verificationId);
  }
} 