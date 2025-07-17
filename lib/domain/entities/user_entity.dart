import 'package:equatable/equatable.dart';

/// 유저(프로필) 엔티티
/// Firestore: users/{uid}
class UserEntity extends Equatable {
  /// 고유 식별자 (Firebase UID)
  final String uid;

  /// 닉네임
  final String nickname;

  /// 감정 태그 리스트 (최소 3개)
  final List<String> emotionTags;

  /// 선호 매칭 시간대 (morning/afternoon/evening)
  final String preferredTime;

  /// 공감 성향 점수 (선택)
  final double? empathyScore;

  /// 생성일시
  final DateTime? createdAt;

  /// 마지막 수정일시
  final DateTime? updatedAt;

  const UserEntity({
    required this.uid,
    required this.nickname,
    required this.emotionTags,
    required this.preferredTime,
    this.empathyScore,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore에서 읽기
  factory UserEntity.fromMap(Map<String, dynamic> map, String uid) {
    return UserEntity(
      uid: uid,
      nickname: map['nickname'] ?? '',
      emotionTags: List<String>.from(map['emotionTags'] ?? []),
      preferredTime: map['preferredTime'] ?? '',
      empathyScore: (map['empathyScore'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  /// Firestore로 저장
  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'emotionTags': emotionTags,
      'preferredTime': preferredTime,
      if (empathyScore != null) 'empathyScore': empathyScore,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uid, nickname, emotionTags, preferredTime, empathyScore, createdAt, updatedAt];
} 