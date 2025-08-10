import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/matching_entity.dart';
import '../../repositories/matching_repository.dart';

/// 매칭 이력을 조회하는 UseCase
/// 
/// 사용자의 과거 매칭 기록을 조회합니다.
class GetMatchingHistoryUseCase {
  GetMatchingHistoryUseCase(this._repository);

  final MatchingRepository _repository;

  /// 매칭 이력을 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// [limit] 조회할 매칭 수 (기본값: 20)
  /// 
  /// Returns:
  /// - 성공 시: 매칭 이력 목록
  /// - 실패 시: Failure 객체
  Future<Either<Failure, List<MatchingEntity>>> call({
    required String userId,
    int limit = 20,
  }) async {
    try {
      final result = await _repository.getMatchingHistory(
        userId: userId,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

 