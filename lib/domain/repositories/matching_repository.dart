import '../entities/matching_entity.dart';

/// 매칭 관련 Repository 인터페이스
abstract class MatchingRepository {
  /// 오늘의 매칭 정보 조회 (없으면 null)
  Future<MatchingEntity?> getTodayMatching(String uid);

  /// 매칭 요청 (서버 트리거)
  Future<void> requestMatching(String uid);
} 