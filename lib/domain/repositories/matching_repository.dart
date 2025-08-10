import '../entities/matching_entity.dart';

/// 매칭 관련 Repository 인터페이스
abstract class MatchingRepository {
  /// 오늘의 매칭 정보 조회 (없으면 null)
  Future<MatchingEntity?> getTodayMatching(String uid);

  /// 매칭 요청 (서버 트리거)
  Future<void> requestMatching(String uid);

  /// 매칭 상태 확인
  Future<bool> isMatched(String userId);

  /// 새로운 매칭 생성
  Future<MatchingEntity> createMatching({
    required String userAId,
    required String userBId,
  });

  /// 매칭 취소
  Future<bool> cancelMatching({
    required String matchingId,
    required String userId,
  });

  /// 사용자의 매칭 이력 조회
  Future<List<MatchingEntity>> getMatchingHistory({
    required String userId,
    int limit = 20,
  });
} 