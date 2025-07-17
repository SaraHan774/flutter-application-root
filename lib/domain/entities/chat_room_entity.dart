import 'package:equatable/equatable.dart';

/// 채팅방(ChatRoom) 엔티티
/// Firestore: chatRooms/{chatRoomId}
class ChatRoomEntity extends Equatable {
  /// 채팅방 고유 ID
  final String chatRoomId;

  /// 참가자 A UID
  final String participantA;

  /// 참가자 B UID
  final String participantB;

  /// 생성 시각
  final DateTime createdAt;

  /// 만료 시각 (24시간 후)
  final DateTime expiresAt;

  /// 종료 여부
  final bool isClosed;

  const ChatRoomEntity({
    required this.chatRoomId,
    required this.participantA,
    required this.participantB,
    required this.createdAt,
    required this.expiresAt,
    required this.isClosed,
  });

  factory ChatRoomEntity.fromMap(Map<String, dynamic> map, String chatRoomId) {
    return ChatRoomEntity(
      chatRoomId: chatRoomId,
      participantA: map['participantA'] ?? '',
      participantB: map['participantB'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      expiresAt: DateTime.parse(map['expiresAt']),
      isClosed: map['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participantA': participantA,
      'participantB': participantB,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isClosed': isClosed,
    };
  }

  @override
  List<Object?> get props => [chatRoomId, participantA, participantB, createdAt, expiresAt, isClosed];
} 