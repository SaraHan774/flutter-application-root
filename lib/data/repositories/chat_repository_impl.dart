import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firestore_chat_datasource.dart';


part 'chat_repository_impl.g.dart';

/// 채팅 Repository 구현체
/// 
/// 채팅 관련 비즈니스 로직을 처리합니다.
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._chatDataSource);

  final FirestoreChatDataSource _chatDataSource;

  @override
  Future<ChatRoomEntity> createChatRoom({
    required String participantAId,
    required String participantBId,
  }) async {
    try {
      final chatRoom = await _chatDataSource.createChatRoom(
        participantAId: participantAId,
        participantBId: participantBId,
      );
      
      return chatRoom.toEntity();
    } catch (e) {
      throw Exception('채팅방 생성 실패: $e');
    }
  }

  @override
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId) async {
    try {
      final chatRoom = await _chatDataSource.getChatRoom(chatRoomId);
      return chatRoom?.toEntity();
    } catch (e) {
      throw Exception('채팅방 조회 실패: $e');
    }
  }

  @override
  Future<ChatRoomEntity?> getActiveChatRoom(String userId) async {
    try {
      final chatRoom = await _chatDataSource.getActiveChatRoom(userId);
      return chatRoom?.toEntity();
    } catch (e) {
      throw Exception('활성 채팅방 조회 실패: $e');
    }
  }

  @override
  Future<bool> closeChatRoom(String chatRoomId) async {
    try {
      return await _chatDataSource.closeChatRoom(chatRoomId);
    } catch (e) {
      throw Exception('채팅방 종료 실패: $e');
    }
  }

  @override
  Future<MessageEntity> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    try {
      final message = await _chatDataSource.sendMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
      );
      
      return message.toEntity();
    } catch (e) {
      throw Exception('메시지 전송 실패: $e');
    }
  }

  @override
  Future<List<MessageEntity>> getMessages(String chatRoomId) async {
    try {
              final messages = await _chatDataSource.getMessages(chatRoomId: chatRoomId);
      
      return messages.map((message) => message.toEntity()).toList();
    } catch (e) {
      throw Exception('메시지 조회 실패: $e');
    }
  }

  @override
  Stream<List<MessageEntity>> subscribeToMessages(String chatRoomId) {
    try {
      return _chatDataSource
          .subscribeToMessages(chatRoomId)
          .map((messages) => messages.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('메시지 스트림 구독 실패: $e');
    }
  }

  @override
  Stream<ChatRoomEntity?> subscribeToChatRoom(String chatRoomId) {
    try {
      return _chatDataSource
          .subscribeToChatRoom(chatRoomId)
          .map((chatRoom) => chatRoom?.toEntity());
    } catch (e) {
      throw Exception('채팅방 스트림 구독 실패: $e');
    }
  }

  @override
  Future<int> closeExpiredChatRooms() async {
    try {
      return await _chatDataSource.closeExpiredChatRooms();
    } catch (e) {
      throw Exception('만료된 채팅방 종료 실패: $e');
    }
  }

  @override
  Future<String?> getOtherParticipantId({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    try {
      return await _chatDataSource.getOtherParticipantId(
        chatRoomId: chatRoomId,
        currentUserId: currentUserId,
      );
    } catch (e) {
      throw Exception('상대방 ID 조회 실패: $e');
    }
  }
}

/// ChatRepositoryImpl Provider
@riverpod
ChatRepositoryImpl chatRepositoryImpl(ChatRepositoryImplRef ref) {
  final firestore = FirebaseFirestore.instance;
  final chatDataSource = FirestoreChatDataSource(firestore);
  return ChatRepositoryImpl(chatDataSource);
}

/// ChatRepository Provider
@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ref.watch(chatRepositoryImplProvider);
} 