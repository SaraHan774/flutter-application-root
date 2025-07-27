import '../../repositories/matching_repository.dart';
import '../../entities/matching_entity.dart';

/// 매칭 생성 UseCase
class CreateMatchingUseCase {
  final MatchingRepository repository;
  CreateMatchingUseCase(this.repository);

  /// 새로운 매칭 생성
  Future<MatchingEntity> call({
    required String userA,
    required String userB,
    required String chatRoomId,
  }) async {
    return await repository.createMatching(
      userA: userA,
      userB: userB,
      chatRoomId: chatRoomId,
    );
  }
} 