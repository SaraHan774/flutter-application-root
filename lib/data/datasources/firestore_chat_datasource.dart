import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_room_model.dart';
import '../models/message_model.dart';

/// 채팅 관련 Firestore 데이터소스
/// 
/// 채팅방과 메시지 데이터의 CRUD 작업을 담당합니다.
class FirestoreChatDataSource {
  const FirestoreChatDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  /// 채팅방 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _chatRoomsCollection =>
      _firestore.collection('chatRooms');

  /// 채팅방을 생성합니다.
  /// 
  /// [participantAId] 참가자 A의 ID
  /// [participantBId] 참가자 B의 ID
  /// 
  /// Returns: 생성된 채팅방 정보
  Future<ChatRoomModel> createChatRoom({
    required String participantAId,
    required String participantBId,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      final chatRoomData = {
        'participantAId': participantAId,
        'participantBId': participantBId,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'isClosed': false,
      };

      final docRef = await _chatRoomsCollection.add(chatRoomData);
      final doc = await docRef.get();
      
      return ChatRoomModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('채팅방 생성 실패: $e');
    }
  }

  /// 채팅방을 조회합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns: 채팅방 정보
  Future<ChatRoomModel?> getChatRoom(String chatRoomId) async {
    try {
      final doc = await _chatRoomsCollection.doc(chatRoomId).get();
      
      if (!doc.exists) return null;
      
      return ChatRoomModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('채팅방 조회 실패: $e');
    }
  }

  /// 사용자의 활성 채팅방을 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// 
  /// Returns: 활성 채팅방 정보 (없으면 null)
  Future<ChatRoomModel?> getActiveChatRoom(String userId) async {
    try {
      final now = DateTime.now();
      
      final query = _chatRoomsCollection
          .where('isClosed', isEqualTo: false)
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(now))
          .where(Filter.or(
            Filter('participantAId', isEqualTo: userId),
            Filter('participantBId', isEqualTo: userId),
          ));

      final snapshot = await query.get();
      
      if (snapshot.docs.isEmpty) return null;
      
      // 가장 최근 채팅방 반환
      final doc = snapshot.docs.first;
      return ChatRoomModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('활성 채팅방 조회 실패: $e');
    }
  }

  /// 채팅방을 종료합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns: 종료 성공 여부
  Future<bool> closeChatRoom(String chatRoomId) async {
    try {
      await _chatRoomsCollection.doc(chatRoomId).update({
        'isClosed': true,
        'closedAt': Timestamp.fromDate(DateTime.now()),
      });
      
      return true;
    } catch (e) {
      throw Exception('채팅방 종료 실패: $e');
    }
  }

  /// 메시지를 전송합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [senderId] 발신자 ID
  /// [text] 메시지 내용
  /// 
  /// Returns: 전송된 메시지 정보
  Future<MessageModel> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    try {
      final now = DateTime.now();
      
      final messageData = {
        'senderId': senderId,
        'text': text,
        'timestamp': Timestamp.fromDate(now),
      };

      // 메시지 추가
      final messageRef = await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      // 채팅방의 마지막 메시지 업데이트
      await _chatRoomsCollection.doc(chatRoomId).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.fromDate(now),
      });

      final messageDoc = await messageRef.get();
      return MessageModel.fromFirestore(messageDoc);
    } catch (e) {
      throw Exception('메시지 전송 실패: $e');
    }
  }

  /// 메시지 목록을 조회합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [limit] 조회할 메시지 수 (기본값: 50)
  /// 
  /// Returns: 메시지 목록
  Future<List<MessageModel>> getMessages({
    required String chatRoomId,
    int limit = 50,
  }) async {
    try {
      final query = _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList()
          .reversed
          .toList(); // 시간순 정렬
    } catch (e) {
      throw Exception('메시지 조회 실패: $e');
    }
  }

  /// 실시간 메시지 스트림을 구독합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns: 메시지 스트림
  Stream<List<MessageModel>> subscribeToMessages(String chatRoomId) {
    return _chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  /// 실시간 채팅방 상태 스트림을 구독합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns: 채팅방 상태 스트림
  Stream<ChatRoomModel?> subscribeToChatRoom(String chatRoomId) {
    return _chatRoomsCollection
        .doc(chatRoomId)
        .snapshots()
        .map((doc) => doc.exists ? ChatRoomModel.fromFirestore(doc) : null);
  }

  /// 만료된 채팅방들을 종료합니다.
  /// 
  /// Returns: 종료된 채팅방 수
  Future<int> closeExpiredChatRooms() async {
    try {
      final now = DateTime.now();
      
      final query = _chatRoomsCollection
          .where('isClosed', isEqualTo: false)
          .where('expiresAt', isLessThan: Timestamp.fromDate(now));

      final snapshot = await query.get();
      
      final batch = _firestore.batch();
      int closedCount = 0;

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isClosed': true,
          'closedAt': Timestamp.fromDate(now),
        });
        closedCount++;
      }

      if (closedCount > 0) {
        await batch.commit();
      }

      return closedCount;
    } catch (e) {
      throw Exception('만료된 채팅방 종료 실패: $e');
    }
  }

  /// 채팅방의 참가자 ID를 가져옵니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [currentUserId] 현재 사용자 ID
  /// 
  /// Returns: 상대방 사용자 ID
  Future<String?> getOtherParticipantId({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    try {
      final doc = await _chatRoomsCollection.doc(chatRoomId).get();
      
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      final participantAId = data['participantAId'] as String;
      final participantBId = data['participantBId'] as String;

      if (currentUserId == participantAId) {
        return participantBId;
      } else if (currentUserId == participantBId) {
        return participantAId;
      }

      return null;
    } catch (e) {
      throw Exception('상대방 ID 조회 실패: $e');
    }
  }
} 