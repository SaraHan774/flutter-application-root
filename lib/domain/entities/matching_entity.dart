import 'package:equatable/equatable.dart';

/// 매칭(Matching) 엔티티
/// Firestore: matchings/{matchingId}
class MatchingEntity extends Equatable {
  /// 매칭 고유 ID
  final String id;

  /// 사용자 A UID
  final String userAId;

  /// 사용자 B UID
  final String userBId;

  /// 채팅방 ID
  final String chatRoomId;

  /// 만료 시각
  final DateTime expiresAt;

  /// 매칭 생성 시각
  final DateTime createdAt;

  /// 매칭 상태 (active/expired)
  final String status;

  const MatchingEntity({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.chatRoomId,
    required this.expiresAt,
    required this.createdAt,
    required this.status,
  });

  factory MatchingEntity.fromMap(Map<String, dynamic> map, String matchingId) {
    return MatchingEntity(
      id: matchingId,
      userAId: map['userAId'] ?? '',
      userBId: map['userBId'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      expiresAt: DateTime.parse(map['expiresAt']),
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userAId': userAId,
      'userBId': userBId,
      'chatRoomId': chatRoomId,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, userAId, userBId, chatRoomId, expiresAt, createdAt, status];
} 