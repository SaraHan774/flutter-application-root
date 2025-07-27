import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room_model.dart';
import '../../domain/entities/chat_room_entity.dart';

/// 채팅 Firestore 데이터소스
class FirestoreChatDataSource {
  final FirebaseFirestore _firestore;

  FirestoreChatDataSource(this._firestore);

  /// 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _chatRoomsCollection =>
      _firestore.collection('chatRooms');

  CollectionReference<Map<String, dynamic>> get _messagesCollection =>
      _firestore.collection('messages');

  /// 채팅방 생성
  Future<ChatRoomEntity> createChatRoom({
    required String participantA,
    required String participantB,
  }) async {
    try {
      final docRef = _chatRoomsCollection.doc();
      final expiresAt = DateTime.now().add(const Duration(hours: 24));
      
      final chatRoom = ChatRoomModel(
        chatRoomId: docRef.id,
        participantA: participantA,
        participantB: participantB,
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
        isClosed: false,
      );

      await docRef.set(chatRoom.toJson());
      return chatRoom;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  /// 채팅방 조회
  Future<ChatRoomEntity?> getChatRoom(String chatRoomId) async {
    try {
      final doc = await _chatRoomsCollection.doc(chatRoomId).get();
      
      if (!doc.exists) {
        return null;
      }

      return ChatRoomModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get chat room: $e');
    }
  }

  /// 사용자의 활성 채팅방 조회
  Future<ChatRoomEntity?> getActiveChatRoom(String userId) async {
    try {
      final now = DateTime.now();
      
      // participantA로 검색
      final querySnapshot1 = await _chatRoomsCollection
          .where('participantA', isEqualTo: userId)
          .where('isClosed', isEqualTo: false)
          .where('expiresAt', isGreaterThan: now.toIso8601String())
          .limit(1)
          .get();

      if (querySnapshot1.docs.isNotEmpty) {
        final doc = querySnapshot1.docs.first;
        return ChatRoomModel.fromJson(doc.data(), doc.id);
      }

      // participantB로 검색
      final querySnapshot2 = await _chatRoomsCollection
          .where('participantB', isEqualTo: userId)
          .where('isClosed', isEqualTo: false)
          .where('expiresAt', isGreaterThan: now.toIso8601String())
          .limit(1)
          .get();

      if (querySnapshot2.docs.isNotEmpty) {
        final doc = querySnapshot2.docs.first;
        return ChatRoomModel.fromJson(doc.data(), doc.id);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get active chat room: $e');
    }
  }

  /// 채팅방 종료
  Future<void> closeChatRoom(String chatRoomId) async {
    try {
      await _chatRoomsCollection.doc(chatRoomId).update({
        'isClosed': true,
      });
    } catch (e) {
      throw Exception('Failed to close chat room: $e');
    }
  }

  /// 메시지 전송
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
    String? messageType = 'text',
  }) async {
    try {
      await _messagesCollection.add({
        'chatRoomId': chatRoomId,
        'senderId': senderId,
        'content': content,
        'messageType': messageType,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// 메시지 조회
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatRoomId) {
    return _messagesCollection
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  /// 만료된 채팅방 정리
  Future<void> cleanupExpiredChatRooms() async {
    try {
      final now = DateTime.now();
      
      final querySnapshot = await _chatRoomsCollection
          .where('expiresAt', isLessThan: now.toIso8601String())
          .where('isClosed', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isClosed': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cleanup expired chat rooms: $e');
    }
  }
} 