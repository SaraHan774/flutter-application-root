import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/matching_entity.dart';
import '../../repositories/matching_repository.dart';

/// 오늘의 매칭을 조회하는 UseCase
/// 
/// 현재 사용자의 오늘 매칭 상태를 확인하고,
/// 매칭이 있다면 매칭 정보를 반환합니다.
class GetTodayMatchingUseCase {
  GetTodayMatchingUseCase(this._repository);

  final MatchingRepository _repository;

  /// 오늘의 매칭을 조회합니다.
  /// 
  /// [userId] 현재 사용자의 ID
  /// 
  /// Returns:
  /// - 성공 시: 오늘의 매칭 정보 (없으면 null)
  /// - 실패 시: Failure 객체
  Future<Either<Failure, MatchingEntity?>> call(String userId) async {
    try {
      final result = await _repository.getTodayMatching(userId);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

 