import '../entities/chat_room_entity.dart';
import '../entities/message_entity.dart';

/// 채팅 관련 Repository 인터페이스
abstract class ChatRepository {
  /// 채팅방 생성
  Future<ChatRoomEntity> createChatRoom({
    required String participantAId,
    required String participantBId,
  });

  /// 채팅방 조회
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId);

  /// 사용자의 활성 채팅방 조회
  Future<ChatRoomEntity?> getActiveChatRoom(String userId);

  /// 채팅방 종료
  Future<bool> closeChatRoom(String chatRoomId);

  /// 메시지 전송
  Future<MessageEntity> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  });

  /// 메시지 목록 조회
  Future<List<MessageEntity>> getMessages(String chatRoomId);

  /// 만료된 채팅방 정리
  Future<int> closeExpiredChatRooms();

  /// 메시지 스트림 구독
  Stream<List<MessageEntity>> subscribeToMessages(String chatRoomId);

  /// 채팅방 스트림 구독
  Stream<ChatRoomEntity?> subscribeToChatRoom(String chatRoomId);

  /// 상대방 ID 조회
  Future<String?> getOtherParticipantId({
    required String chatRoomId,
    required String currentUserId,
  });
} 