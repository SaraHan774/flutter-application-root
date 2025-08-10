import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_room_entity.dart';

/// 채팅방 데이터 모델 (DTO)
/// 
/// Firestore에서 채팅방 데이터를 주고받을 때 사용하는 모델입니다.
class ChatRoomModel {
  const ChatRoomModel({
    required this.id,
    required this.participantAId,
    required this.participantBId,
    required this.createdAt,
    required this.expiresAt,
    required this.isClosed,
    this.lastMessage,
    this.lastMessageTime,
  });

  /// 채팅방 ID
  final String id;
  
  /// 참가자 A의 ID
  final String participantAId;
  
  /// 참가자 B의 ID
  final String participantBId;
  
  /// 채팅방 생성 시간
  final DateTime createdAt;
  
  /// 채팅방 만료 시간 (24시간 후)
  final DateTime expiresAt;
  
  /// 채팅방 종료 여부
  final bool isClosed;
  
  /// 마지막 메시지 (선택사항)
  final String? lastMessage;
  
  /// 마지막 메시지 시간 (선택사항)
  final DateTime? lastMessageTime;

  /// Firestore 문서에서 ChatRoomModel 생성
  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ChatRoomModel(
      id: doc.id,
      participantAId: data['participantAId'] as String,
      participantBId: data['participantBId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isClosed: data['isClosed'] as bool? ?? false,
      lastMessage: data['lastMessage'] as String?,
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  /// ChatRoomModel을 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'participantAId': participantAId,
      'participantBId': participantBId,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isClosed': isClosed,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': Timestamp.fromDate(lastMessageTime!),
    };
  }

  /// ChatRoomModel을 ChatRoomEntity로 변환
  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      id: id,
      participantAId: participantAId,
      participantBId: participantBId,
      createdAt: createdAt,
      expiresAt: expiresAt,
      isClosed: isClosed,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }

  /// ChatRoomEntity에서 ChatRoomModel 생성
  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      participantAId: entity.participantAId,
      participantBId: entity.participantBId,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      isClosed: entity.isClosed,
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
    );
  }

  /// 채팅방이 만료되었는지 확인
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 채팅방이 활성 상태인지 확인
  bool get isActive => !isClosed && !isExpired;

  /// 남은 시간을 계산 (분 단위)
  int get remainingMinutes {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return 0;
    return expiresAt.difference(now).inMinutes;
  }

  /// 남은 시간을 시:분 형식으로 반환
  String get remainingTimeString {
    final minutes = remainingMinutes;
    if (minutes <= 0) return '00:00';
    
    final hours = minutes ~/ 60;
    final remainingMins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMins.toString().padLeft(2, '0')}';
  }

  /// 복사본 생성
  ChatRoomModel copyWith({
    String? id,
    String? participantAId,
    String? participantBId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isClosed,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      participantAId: participantAId ?? this.participantAId,
      participantBId: participantBId ?? this.participantBId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isClosed: isClosed ?? this.isClosed,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoomModel &&
        other.id == id &&
        other.participantAId == participantAId &&
        other.participantBId == participantBId &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.isClosed == isClosed &&
        other.lastMessage == lastMessage &&
        other.lastMessageTime == lastMessageTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      participantAId,
      participantBId,
      createdAt,
      expiresAt,
      isClosed,
      lastMessage,
      lastMessageTime,
    );
  }

  @override
  String toString() {
    return 'ChatRoomModel(id: $id, participantAId: $participantAId, '
           'participantBId: $participantBId, createdAt: $createdAt, '
           'expiresAt: $expiresAt, isClosed: $isClosed, '
           'lastMessage: $lastMessage, lastMessageTime: $lastMessageTime)';
  }
} 