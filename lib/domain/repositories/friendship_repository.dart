import '../entities/friendship_entity.dart';

/// 말벗 친구 관련 Repository 인터페이스
abstract class FriendshipRepository {
  /// 친구 목록 조회
  Future<List<FriendshipEntity>> getFriendList(String uid);
} 