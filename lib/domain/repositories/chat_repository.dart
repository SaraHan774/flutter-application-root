import '../entities/chat_room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 채팅 관련 Repository 인터페이스
abstract class ChatRepository {
  /// 채팅방 생성
  Future<ChatRoomEntity> createChatRoom({
    required String participantA,
    required String participantB,
  });

  /// 채팅방 조회
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId);

  /// 사용자의 활성 채팅방 조회
  Future<ChatRoomEntity?> getActiveChatRoom(String userId);

  /// 채팅방 종료
  Future<void> closeChatRoom(String chatRoomId);

  /// 메시지 전송
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
    String? messageType,
  });

  /// 메시지 스트림 조회
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatRoomId);

  /// 만료된 채팅방 정리
  Future<void> cleanupExpiredChatRooms();
} 