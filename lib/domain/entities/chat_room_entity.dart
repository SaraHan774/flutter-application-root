import 'package:equatable/equatable.dart';

/// 채팅방(ChatRoom) 엔티티
/// Firestore: chatRooms/{chatRoomId}
class ChatRoomEntity extends Equatable {
  /// 채팅방 고유 ID
  final String id;

  /// 참가자 A UID
  final String participantAId;

  /// 참가자 B UID
  final String participantBId;

  /// 생성 시각
  final DateTime createdAt;

  /// 만료 시각 (24시간 후)
  final DateTime expiresAt;

  /// 종료 여부
  final bool isClosed;

  /// 마지막 메시지
  final String? lastMessage;

  /// 마지막 메시지 시간
  final DateTime? lastMessageTime;

  const ChatRoomEntity({
    required this.id,
    required this.participantAId,
    required this.participantBId,
    required this.createdAt,
    required this.expiresAt,
    required this.isClosed,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatRoomEntity.fromMap(Map<String, dynamic> map, String chatRoomId) {
    return ChatRoomEntity(
      id: chatRoomId,
      participantAId: map['participantAId'] ?? '',
      participantBId: map['participantBId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      expiresAt: DateTime.parse(map['expiresAt']),
      isClosed: map['isClosed'] ?? false,
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null 
          ? DateTime.parse(map['lastMessageTime']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participantAId': participantAId,
      'participantBId': participantBId,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isClosed': isClosed,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, participantAId, participantBId, createdAt, expiresAt, isClosed, lastMessage, lastMessageTime];
} 