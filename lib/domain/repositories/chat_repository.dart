import '../entities/chat_room_entity.dart';
import '../entities/message_entity.dart';

/// 채팅 관련 Repository 인터페이스
abstract class ChatRepository {
  /// 채팅방 정보 조회
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId);

  /// 채팅방 메시지 스트림
  Stream<List<MessageEntity>> getMessagesStream(String chatRoomId);

  /// 메시지 전송
  Future<void> sendMessage(String chatRoomId, MessageEntity message);
} 