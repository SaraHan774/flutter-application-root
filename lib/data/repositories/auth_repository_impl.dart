import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_user_datasource.dart';
import '../models/user_model.dart';

/// Auth Repository 구현체
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final FirestoreUserDataSource _userDataSource;

  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  @override
  Future<void> sendPhoneVerificationCode(String phoneNumber) async {
    await _authDataSource.sendPhoneVerificationCode(phoneNumber);
  }

  @override
  Future<UserEntity> verifyPhoneCode({
    required String phoneNumber,
    required String smsCode,
    required String verificationId,
  }) async {
    // Firebase Auth로 인증
    final firebaseUser = await _authDataSource.verifyPhoneCode(
      phoneNumber: phoneNumber,
      smsCode: smsCode,
      verificationId: verificationId,
    );

    // Firestore에서 사용자 프로필 조회
    final userModel = await _userDataSource.getUserById(firebaseUser.uid);
    
    if (userModel == null) {
      // 새 사용자인 경우 기본 UserEntity 반환 (프로필 설정 필요)
      return UserEntity(
        uid: firebaseUser.uid,
        nickname: '',
        emotionTags: [],
        preferredTime: '',
      );
    }

    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _authDataSource.getCurrentUser();
    if (firebaseUser == null) return null;

    final userModel = await _userDataSource.getUserById(firebaseUser.uid);
    return userModel?.toEntity();
  }
} 