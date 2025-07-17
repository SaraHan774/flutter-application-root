import 'package:equatable/equatable.dart';

/// 채팅 메시지(Message) 엔티티
/// Firestore: chatRooms/{chatRoomId}/messages/{messageId}
class MessageEntity extends Equatable {
  /// 메시지 고유 ID
  final String messageId;

  /// 보낸 사람 UID
  final String senderId;

  /// 메시지 텍스트
  final String text;

  /// 전송 시각
  final DateTime timestamp;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MessageEntity.fromMap(Map<String, dynamic> map, String messageId) {
    return MessageEntity(
      messageId: messageId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [messageId, senderId, text, timestamp];
} 