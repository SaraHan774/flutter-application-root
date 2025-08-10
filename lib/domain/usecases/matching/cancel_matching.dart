import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../repositories/matching_repository.dart';



/// 매칭을 취소하는 UseCase
/// 
/// 진행 중인 매칭을 취소하고 관련 채팅방을 종료합니다.
class CancelMatchingUseCase {
  CancelMatchingUseCase(this._repository);

  final MatchingRepository _repository;

  /// 매칭을 취소합니다.
  /// 
  /// [matchingId] 취소할 매칭의 ID
  /// [userId] 매칭을 취소하는 사용자 ID
  /// 
  /// Returns:
  /// - 성공 시: true
  /// - 실패 시: Failure 객체
  Future<Either<Failure, bool>> call({
    required String matchingId,
    required String userId,
  }) async {
    try {
      final result = await _repository.cancelMatching(
        matchingId: matchingId,
        userId: userId,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

 