import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/matching_entity.dart';

/// 매칭 데이터 모델 (DTO)
/// 
/// Firestore에서 매칭 데이터를 주고받을 때 사용하는 모델입니다.
class MatchingModel {
  const MatchingModel({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.chatRoomId,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
  });

  /// 매칭 ID
  final String id;
  
  /// 첫 번째 사용자 ID
  final String userAId;
  
  /// 두 번째 사용자 ID
  final String userBId;
  
  /// 채팅방 ID
  final String chatRoomId;
  
  /// 매칭 생성 시간
  final DateTime createdAt;
  
  /// 매칭 만료 시간 (24시간 후)
  final DateTime expiresAt;
  
  /// 매칭 상태 (active, expired, cancelled)
  final String status;

  /// Firestore 문서에서 MatchingModel 생성
  factory MatchingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return MatchingModel(
      id: doc.id,
      userAId: data['userAId'] as String,
      userBId: data['userBId'] as String,
      chatRoomId: data['chatRoomId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      status: data['status'] as String? ?? 'active',
    );
  }

  /// MatchingModel을 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'userAId': userAId,
      'userBId': userBId,
      'chatRoomId': chatRoomId,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'status': status,
    };
  }

  /// MatchingModel을 MatchingEntity로 변환
  MatchingEntity toEntity() {
    return MatchingEntity(
      id: id,
      userAId: userAId,
      userBId: userBId,
      chatRoomId: chatRoomId,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status,
    );
  }

  /// MatchingEntity에서 MatchingModel 생성
  factory MatchingModel.fromEntity(MatchingEntity entity) {
    return MatchingModel(
      id: entity.id,
      userAId: entity.userAId,
      userBId: entity.userBId,
      chatRoomId: entity.chatRoomId,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      status: entity.status,
    );
  }

  /// 매칭이 만료되었는지 확인
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 매칭이 활성 상태인지 확인
  bool get isActive => status == 'active' && !isExpired;

  /// 매칭이 취소되었는지 확인
  bool get isCancelled => status == 'cancelled';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchingModel &&
        other.id == id &&
        other.userAId == userAId &&
        other.userBId == userBId &&
        other.chatRoomId == chatRoomId &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userAId,
      userBId,
      chatRoomId,
      createdAt,
      expiresAt,
      status,
    );
  }

  @override
  String toString() {
    return 'MatchingModel(id: $id, userAId: $userAId, userBId: $userBId, '
           'chatRoomId: $chatRoomId, createdAt: $createdAt, '
           'expiresAt: $expiresAt, status: $status)';
  }
} 