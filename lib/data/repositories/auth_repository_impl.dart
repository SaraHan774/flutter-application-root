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
  Future<String> sendPhoneVerificationCode(String phoneNumber) async {
    return await _authDataSource.sendPhoneVerificationCode(phoneNumber);
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
      // 새 사용자인 경우 기본 UserEntity 생성 및 Firestore에 저장
      final newUser = UserEntity(
        uid: firebaseUser.uid,
        nickname: '',
        emotionTags: [],
        preferredTime: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Firestore에 기본 사용자 정보 저장
      await _userDataSource.createUserProfile(UserModel.fromEntity(newUser));
      
      return newUser;
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