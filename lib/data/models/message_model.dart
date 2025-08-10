import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';

/// 메시지 데이터 모델 (DTO)
/// 
/// Firestore에서 메시지 데이터를 주고받을 때 사용하는 모델입니다.
class MessageModel {
  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  /// 메시지 ID
  final String id;
  
  /// 발신자 ID
  final String senderId;
  
  /// 메시지 내용
  final String text;
  
  /// 전송 시간
  final DateTime timestamp;
  
  /// 읽음 여부
  final bool isRead;

  /// Firestore 문서에서 MessageModel 생성
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  /// MessageModel을 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  /// MessageModel을 MessageEntity로 변환
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      text: text,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  /// MessageEntity에서 MessageModel 생성
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      text: entity.text,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
    );
  }

  /// 메시지가 내가 보낸 것인지 확인
  bool isFromMe(String currentUserId) => senderId == currentUserId;

  /// 메시지가 오늘 보낸 것인지 확인
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    return today.isAtSameMomentAs(messageDate);
  }

  /// 메시지가 어제 보낸 것인지 확인
  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    return yesterday.isAtSameMomentAs(messageDate);
  }

  /// 메시지 시간을 포맷팅 (오늘: HH:mm, 어제: 어제 HH:mm, 그 외: MM/dd HH:mm)
  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    final timeString = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    if (messageDate.isAtSameMomentAs(today)) {
      return timeString;
    } else if (messageDate.isAtSameMomentAs(yesterday)) {
      return '어제 $timeString';
    } else {
      return '${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} $timeString';
    }
  }

  /// 복사본 생성
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.id == id &&
        other.senderId == senderId &&
        other.text == text &&
        other.timestamp == timestamp &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      senderId,
      text,
      timestamp,
      isRead,
    );
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, text: $text, '
           'timestamp: $timestamp, isRead: $isRead)';
  }
}
