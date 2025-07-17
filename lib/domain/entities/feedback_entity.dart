import 'package:equatable/equatable.dart';

/// 피드백(Feedback) 엔티티
/// Firestore: feedbacks/{chatRoomId}_{userId}
class FeedbackEntity extends Equatable {
  /// 피드백 고유 ID (chatRoomId_userId)
  final String feedbackId;

  /// 피드백 작성자 UID
  final String fromUserId;

  /// 피드백 대상 UID
  final String toUserId;

  /// 감정 키워드 리스트
  final List<String> emotions;

  /// 생성 시각
  final DateTime createdAt;

  /// 채팅방 ID
  final String chatRoomId;

  const FeedbackEntity({
    required this.feedbackId,
    required this.fromUserId,
    required this.toUserId,
    required this.emotions,
    required this.createdAt,
    required this.chatRoomId,
  });

  factory FeedbackEntity.fromMap(Map<String, dynamic> map, String feedbackId) {
    return FeedbackEntity(
      feedbackId: feedbackId,
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      emotions: List<String>.from(map['emotions'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      chatRoomId: map['chatRoomId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'emotions': emotions,
      'createdAt': createdAt.toIso8601String(),
      'chatRoomId': chatRoomId,
    };
  }

  @override
  List<Object?> get props => [feedbackId, fromUserId, toUserId, emotions, createdAt, chatRoomId];
} 