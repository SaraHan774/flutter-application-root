import '../../repositories/user_repository.dart';
import '../../entities/user_entity.dart';

/// 사용자 프로필 조회 UseCase
class GetUserProfileUseCase {
  final UserRepository repository;
  GetUserProfileUseCase(this.repository);

  /// UID로 사용자 프로필 조회
  Future<UserEntity?> call(String uid) async {
    return await repository.getUserById(uid);
  }
} 