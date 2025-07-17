import 'package:equatable/equatable.dart';

/// 말벗 친구(Friendship) 엔티티
/// Firestore: friendships/{userId}
class FriendshipEntity extends Equatable {
  /// 친구 고유 ID (상대 UID)
  final String friendId;

  /// 첫 연결 시각
  final DateTime firstConnectedAt;

  /// 하루 대화 가능 횟수
  final int chatQuotaPerDay;

  const FriendshipEntity({
    required this.friendId,
    required this.firstConnectedAt,
    required this.chatQuotaPerDay,
  });

  factory FriendshipEntity.fromMap(Map<String, dynamic> map, String friendId) {
    return FriendshipEntity(
      friendId: friendId,
      firstConnectedAt: DateTime.parse(map['firstConnectedAt']),
      chatQuotaPerDay: map['chatQuotaPerDay'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstConnectedAt': firstConnectedAt.toIso8601String(),
      'chatQuotaPerDay': chatQuotaPerDay,
    };
  }

  @override
  List<Object?> get props => [friendId, firstConnectedAt, chatQuotaPerDay];
}