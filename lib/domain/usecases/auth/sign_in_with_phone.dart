import '../../repositories/auth_repository.dart';

/// 전화번호 인증(SMS 전송) UseCase
class SignInWithPhoneUseCase {
  final AuthRepository repository;
  SignInWithPhoneUseCase(this.repository);

  /// 전화번호로 인증 SMS 전송
  Future<String> call(String phoneNumber) async {
    // 실제 구현은 repository를 통해 위임
    return await repository.sendPhoneVerificationCode(phoneNumber);
  }
} 