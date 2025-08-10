import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';

part 'auth_provider.g.dart';

/// 인증 상태 관리 Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  String? _verificationId;
  
  @override
  FutureOr<UserEntity?> build() async {
    // Firebase Auth의 현재 사용자 상태를 확인
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.getCurrentUser();
      
      if (user != null) {
        print('[한담] [AUTH] User loaded: ${user.uid}, profile complete: ${user.isProfileComplete}');
      } else {
        print('[한담] [AUTH] No user found');
      }
      
      return user;
    } catch (error, stackTrace) {
      print('[한담] [AUTH] Error loading user: $error');
      throw error;
    }
  }



  /// 전화번호 인증 시작
  Future<String> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();
      
      final signInUseCase = SignInWithPhoneUseCase(
        ref.read(authRepositoryProvider),
      );
      
      _verificationId = await signInUseCase.call(phoneNumber);
      
      // 성공 시 상태는 그대로 유지 (아직 로그인되지 않음)
      state = const AsyncValue.data(null);
      
      return _verificationId!;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// 저장된 verificationId 반환
  String? get verificationId => _verificationId;

  /// 에러 상태 초기화
  void resetError() {
    state = const AsyncValue.data(null);
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
      // 에러를 다시 던져서 UI에서 처리할 수 있도록 함
      rethrow;
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
      
      if (user != null) {
        print('[한담] [AUTH] User refreshed: ${user.uid}, profile complete: ${user.isProfileComplete}');
      }
    } catch (error, stackTrace) {
      print('[한담] [AUTH] Error refreshing user: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 인증 Repository Provider
@riverpod
AuthRepository authRepository(Ref ref) {
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  
  final authDataSource = FirebaseAuthDataSource(firebaseAuth);
  final userDataSource = FirestoreUserDataSource(firestore);
  
  return AuthRepositoryImpl(authDataSource, userDataSource);
}

/// 사용자 Repository Provider
@riverpod
UserRepository userRepository(Ref ref) {
  final firestore = FirebaseFirestore.instance;
  final userDataSource = FirestoreUserDataSource(firestore);
  
  return UserRepositoryImpl(userDataSource);
}

 