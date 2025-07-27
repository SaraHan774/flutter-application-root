import '../../domain/entities/matching_entity.dart';

/// 매칭 DTO 모델
class MatchingModel extends MatchingEntity {
  const MatchingModel({
    required super.matchingId,
    required super.userA,
    required super.userB,
    required super.chatRoomId,
    required super.createdAt,
    required super.status,
  });

  /// JSON에서 MatchingModel 생성
  factory MatchingModel.fromJson(Map<String, dynamic> json, String matchingId) {
    return MatchingModel(
      matchingId: matchingId,
      userA: json['userA'] as String? ?? '',
      userB: json['userB'] as String? ?? '',
      chatRoomId: json['chatRoomId'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'active',
    );
  }

  /// MatchingModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'userA': userA,
      'userB': userB,
      'chatRoomId': chatRoomId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  /// MatchingEntity를 MatchingModel로 변환
  factory MatchingModel.fromEntity(MatchingEntity entity) {
    return MatchingModel(
      matchingId: entity.matchingId,
      userA: entity.userA,
      userB: entity.userB,
      chatRoomId: entity.chatRoomId,
      createdAt: entity.createdAt,
      status: entity.status,
    );
  }

  /// 복사본 생성
  MatchingModel copyWith({
    String? matchingId,
    String? userA,
    String? userB,
    String? chatRoomId,
    DateTime? createdAt,
    String? status,
  }) {
    return MatchingModel(
      matchingId: matchingId ?? this.matchingId,
      userA: userA ?? this.userA,
      userB: userB ?? this.userB,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
} 