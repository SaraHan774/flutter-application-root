import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/matching_entity.dart';
import '../../repositories/matching_repository.dart';



/// 매칭을 생성하는 UseCase
/// 
/// 두 사용자 간의 매칭을 생성하고 채팅방을 만듭니다.
class CreateMatchingUseCase {
  CreateMatchingUseCase(this._repository);

  final MatchingRepository _repository;

  /// 매칭을 생성합니다.
  /// 
  /// [userAId] 첫 번째 사용자 ID
  /// [userBId] 두 번째 사용자 ID
  /// 
  /// Returns:
  /// - 성공 시: 생성된 매칭 정보
  /// - 실패 시: Failure 객체
  Future<Either<Failure, MatchingEntity>> call({
    required String userAId,
    required String userBId,
  }) async {
    try {
      final result = await _repository.createMatching(
        userAId: userAId,
        userBId: userBId,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

 