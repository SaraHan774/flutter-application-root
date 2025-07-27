import '../../repositories/matching_repository.dart';

/// 매칭 취소 UseCase
class CancelMatchingUseCase {
  final MatchingRepository repository;
  CancelMatchingUseCase(this.repository);

  /// 매칭 취소
  Future<void> call(String matchingId) async {
    await repository.cancelMatching(matchingId);
  }
} 