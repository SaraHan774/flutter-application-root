import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../datasources/firestore_chat_datasource.dart';
import '../../core/error/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 채팅 Repository 구현체
class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<ChatRoomEntity> createChatRoom({
    required String participantA,
    required String participantB,
  }) async {
    try {
      return await _chatDataSource.createChatRoom(
        participantA: participantA,
        participantB: participantB,
      );
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId) async {
    try {
      return await _chatDataSource.getChatRoom(chatRoomId);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<ChatRoomEntity?> getActiveChatRoom(String userId) async {
    try {
      return await _chatDataSource.getActiveChatRoom(userId);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<void> closeChatRoom(String chatRoomId) async {
    try {
      await _chatDataSource.closeChatRoom(chatRoomId);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
    String? messageType,
  }) async {
    try {
      await _chatDataSource.sendMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        content: content,
        messageType: messageType,
      );
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatRoomId) {
    try {
      return _chatDataSource.getMessagesStream(chatRoomId);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<void> cleanupExpiredChatRooms() async {
    try {
      await _chatDataSource.cleanupExpiredChatRooms();
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }
} 