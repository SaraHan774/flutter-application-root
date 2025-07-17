import '../entities/user_entity.dart';

/// 사용자(프로필) 관련 Repository 인터페이스
abstract class UserRepository {
  /// UID로 사용자 프로필 조회
  Future<UserEntity?> getUserById(String uid);

  /// 닉네임 중복 검사
  Future<bool> isNicknameDuplicate(String nickname);

  /// 프로필 생성
  Future<void> createUserProfile(UserEntity user);

  /// 프로필 업데이트
  Future<void> updateUserProfile(UserEntity user);
} 