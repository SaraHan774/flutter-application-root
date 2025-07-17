import '../entities/connection_request_entity.dart';

/// 연결 요청 관련 Repository 인터페이스
abstract class ConnectionRepository {
  /// 연결 요청 전송
  Future<void> sendConnectionRequest(String chatRoomId, String userId);

  /// 연결 상태 확인
  Future<ConnectionRequestEntity?> getConnectionStatus(String chatRoomId);
} 