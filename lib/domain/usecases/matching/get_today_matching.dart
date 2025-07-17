import '../../repositories/matching_repository.dart';
import '../../entities/matching_entity.dart';

/// 오늘의 매칭 조회 UseCase
class GetTodayMatchingUseCase {
  final MatchingRepository repository;
  GetTodayMatchingUseCase(this.repository);

  /// 오늘의 매칭 정보 조회
  Future<MatchingEntity?> call(String uid) async {
    return await repository.getTodayMatching(uid);
  }
} 