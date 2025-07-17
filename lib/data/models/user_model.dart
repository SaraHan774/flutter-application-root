import '../../domain/entities/user_entity.dart';

/// User DTO 모델 - Firestore와 Entity 간 변환
class UserModel {
  final String uid;
  final String nickname;
  final List<String> emotionTags;
  final String preferredTime;
  final double? empathyScore;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.uid,
    required this.nickname,
    required this.emotionTags,
    required this.preferredTime,
    this.empathyScore,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore Map에서 UserModel 생성
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      nickname: map['nickname'] ?? '',
      emotionTags: List<String>.from(map['emotionTags'] ?? []),
      preferredTime: map['preferredTime'] ?? '',
      empathyScore: (map['empathyScore'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  /// UserModel을 Firestore Map으로 변환
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

  /// UserModel을 UserEntity로 변환
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      nickname: nickname,
      emotionTags: emotionTags,
      preferredTime: preferredTime,
      empathyScore: empathyScore,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// UserEntity에서 UserModel 생성
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      nickname: entity.nickname,
      emotionTags: entity.emotionTags,
      preferredTime: entity.preferredTime,
      empathyScore: entity.empathyScore,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
} 