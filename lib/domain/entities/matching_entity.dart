import 'package:equatable/equatable.dart';

/// 매칭(Matching) 엔티티
/// Firestore: matchings/{matchingId}
class MatchingEntity extends Equatable {
  /// 매칭 고유 ID
  final String matchingId;

  /// 사용자 A UID
  final String userA;

  /// 사용자 B UID
  final String userB;

  /// 채팅방 ID
  final String chatRoomId;

  /// 매칭 생성 시각
  final DateTime createdAt;

  /// 매칭 상태 (active/expired)
  final String status;

  const MatchingEntity({
    required this.matchingId,
    required this.userA,
    required this.userB,
    required this.chatRoomId,
    required this.createdAt,
    required this.status,
  });

  factory MatchingEntity.fromMap(Map<String, dynamic> map, String matchingId) {
    return MatchingEntity(
      matchingId: matchingId,
      userA: map['userA'] ?? '',
      userB: map['userB'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userA': userA,
      'userB': userB,
      'chatRoomId': chatRoomId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [matchingId, userA, userB, chatRoomId, createdAt, status];
} 