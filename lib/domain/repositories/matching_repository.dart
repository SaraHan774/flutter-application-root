import '../entities/matching_entity.dart';

/// 매칭 관련 Repository 인터페이스
abstract class MatchingRepository {
  /// 오늘의 매칭 정보 조회 (없으면 null)
  Future<MatchingEntity?> getTodayMatching(String uid);

  /// 매칭 요청 (서버 트리거)
  Future<void> requestMatching(String uid);

  /// 새로운 매칭 생성
  Future<MatchingEntity> createMatching({
    required String userA,
    required String userB,
    required String chatRoomId,
  });

  /// 매칭 취소
  Future<void> cancelMatching(String matchingId);

  /// 사용자의 매칭 이력 조회
  Future<List<MatchingEntity>> getMatchingHistory({
    required String uid,
    int limit = 20,
    DateTime? beforeDate,
  });
} 