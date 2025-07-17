import '../entities/feedback_entity.dart';

/// 피드백 관련 Repository 인터페이스
abstract class FeedbackRepository {
  /// 피드백 제출
  Future<void> submitFeedback(FeedbackEntity feedback);
} 