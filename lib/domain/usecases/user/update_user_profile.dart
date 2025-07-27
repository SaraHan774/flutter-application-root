import '../../repositories/user_repository.dart';
import '../../entities/user_entity.dart';

/// 사용자 프로필 업데이트 UseCase
class UpdateUserProfileUseCase {
  final UserRepository repository;
  UpdateUserProfileUseCase(this.repository);

  /// 사용자 프로필 업데이트
  Future<UserEntity> call({
    required String userId,
    String? nickname,
    List<String>? emotionTags,
    String? preferredTime,
    double? empathyScore,
  }) async {
    // 기존 사용자 정보 조회
    final existingUser = await repository.getUserById(userId);
    
    // 업데이트된 사용자 엔티티 생성
    final updatedUser = UserEntity(
      uid: userId,
      nickname: nickname ?? existingUser?.nickname ?? '',
      emotionTags: emotionTags ?? existingUser?.emotionTags ?? [],
      preferredTime: preferredTime ?? existingUser?.preferredTime ?? '',
      empathyScore: empathyScore ?? existingUser?.empathyScore ?? 0.0,
    );
    
    // 저장소에 업데이트
    await repository.updateUserProfile(updatedUser);
    
    return updatedUser;
  }
} 