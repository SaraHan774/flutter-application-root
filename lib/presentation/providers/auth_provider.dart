import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/core.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth/sign_in_with_phone.dart';
import '../../domain/usecases/auth/verify_phone_code.dart';
import '../../data/data.dart';

part 'auth_provider.g.dart';

/// 인증 상태 관리 Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserEntity?> build() {
    // 초기 상태는 null (로그인되지 않음)
    return null;
  }

  /// 전화번호 인증 시작
  Future<void> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();
      
      final signInUseCase = SignInWithPhoneUseCase(
        ref.read(authRepositoryProvider),
      );
      
      await signInUseCase.call(phoneNumber);
      
      // 성공 시 상태는 그대로 유지 (아직 로그인되지 않음)
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 인증번호 확인 및 로그인
  Future<void> verifyPhoneCode({
    required String phoneNumber,
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final verifyUseCase = VerifyPhoneCodeUseCase(
        ref.read(authRepositoryProvider),
      );
      
      final user = await verifyUseCase.call(
        phoneNumber: phoneNumber,
        smsCode: smsCode,
        verificationId: verificationId,
      );
      
      // 로그인 성공 시 사용자 정보 저장
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      
      // 로그아웃 성공 시 상태를 null로 초기화
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 현재 사용자 정보 새로고침
  Future<void> refreshCurrentUser() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 인증 Repository Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  
  final authDataSource = FirebaseAuthDataSource(firebaseAuth);
  final userDataSource = FirestoreUserDataSource(firestore);
  
  return AuthRepositoryImpl(authDataSource, userDataSource);
}

/// 사용자 Repository Provider
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  final userDataSource = FirestoreUserDataSource(firestore);
  
  return UserRepositoryImpl(userDataSource);
} 