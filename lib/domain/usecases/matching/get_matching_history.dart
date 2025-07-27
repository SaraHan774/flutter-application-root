import '../../repositories/matching_repository.dart';
import '../../entities/matching_entity.dart';

/// 매칭 이력 조회 UseCase
class GetMatchingHistoryUseCase {
  final MatchingRepository repository;
  GetMatchingHistoryUseCase(this.repository);

  /// 사용자의 매칭 이력 조회
  Future<List<MatchingEntity>> call({
    required String uid,
    int limit = 20,
    DateTime? beforeDate,
  }) async {
    return await repository.getMatchingHistory(
      uid: uid,
      limit: limit,
      beforeDate: beforeDate,
    );
  }
} 