import '../../repositories/user_repository.dart';
import '../../entities/user_entity.dart';

/// 사용자 프로필 업데이트 UseCase
class UpdateUserProfileUseCase {
  final UserRepository repository;
  UpdateUserProfileUseCase(this.repository);

  /// 사용자 프로필 업데이트
  Future<void> call(UserEntity user) async {
    await repository.updateUserProfile(user);
  }
} 