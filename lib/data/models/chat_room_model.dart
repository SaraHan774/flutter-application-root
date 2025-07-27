import '../../domain/entities/chat_room_entity.dart';

/// 채팅방 DTO 모델
class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.chatRoomId,
    required super.participantA,
    required super.participantB,
    required super.createdAt,
    required super.expiresAt,
    required super.isClosed,
  });

  /// JSON에서 ChatRoomModel 생성
  factory ChatRoomModel.fromJson(Map<String, dynamic> json, String chatRoomId) {
    return ChatRoomModel(
      chatRoomId: chatRoomId,
      participantA: json['participantA'] as String? ?? '',
      participantB: json['participantB'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }

  /// ChatRoomModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'participantA': participantA,
      'participantB': participantB,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isClosed': isClosed,
    };
  }

  /// ChatRoomEntity를 ChatRoomModel로 변환
  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      chatRoomId: entity.chatRoomId,
      participantA: entity.participantA,
      participantB: entity.participantB,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      isClosed: entity.isClosed,
    );
  }

  /// 복사본 생성
  ChatRoomModel copyWith({
    String? chatRoomId,
    String? participantA,
    String? participantB,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isClosed,
  }) {
    return ChatRoomModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      participantA: participantA ?? this.participantA,
      participantB: participantB ?? this.participantB,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isClosed: isClosed ?? this.isClosed,
    );
  }
} 