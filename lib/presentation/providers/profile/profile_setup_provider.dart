import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:handam/domain/entities/user_entity.dart';

part 'profile_setup_provider.g.dart';

/// 프로필 설정 상태 모델
class ProfileSetupState {
  final String? nickname;
  final List<String> emotionTags;
  final String? preferredTime;
  final Map<int, String> surveyAnswers;
  final int currentStep;
  final bool isLoading;
  final String? error;

  const ProfileSetupState({
    this.nickname,
    this.emotionTags = const [],
    this.preferredTime,
    this.surveyAnswers = const {},
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
  });

  ProfileSetupState copyWith({
    String? nickname,
    List<String>? emotionTags,
    String? preferredTime,
    Map<int, String>? surveyAnswers,
    int? currentStep,
    bool? isLoading,
    String? error,
  }) {
    return ProfileSetupState(
      nickname: nickname ?? this.nickname,
      emotionTags: emotionTags ?? this.emotionTags,
      preferredTime: preferredTime ?? this.preferredTime,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 프로필 설정 완료 여부 확인
  bool get isComplete {
    return nickname != null && 
           emotionTags.length >= 3 && 
           preferredTime != null;
  }

  /// 현재 단계별 완료 여부 확인
  bool get isCurrentStepComplete {
    switch (currentStep) {
      case 0: // 닉네임 설정
        return nickname != null && nickname!.isNotEmpty;
      case 1: // 감정 키워드 선택
        return emotionTags.length >= 3;
      case 2: // 시간대 선택
        return preferredTime != null;
      case 3: // 설문 (선택사항)
        return true; // 설문은 선택사항이므로 항상 완료로 간주
      default:
        return false;
    }
  }
}

/// 프로필 설정 상태 관리 Provider
@riverpod
class ProfileSetupNotifier extends _$ProfileSetupNotifier {
  @override
  ProfileSetupState build() {
    return const ProfileSetupState();
  }

  /// 닉네임 설정
  void setNickname(String nickname) {
    state = state.copyWith(
      nickname: nickname,
      error: null,
    );
  }

  /// 감정 키워드 설정
  void setEmotionTags(List<String> emotionTags) {
    state = state.copyWith(
      emotionTags: emotionTags,
      error: null,
    );
  }

  /// 시간대 설정
  void setPreferredTime(String preferredTime) {
    state = state.copyWith(
      preferredTime: preferredTime,
      error: null,
    );
  }

  /// 설문 답변 설정
  void setSurveyAnswer(int questionId, String answer) {
    final updatedAnswers = Map<int, String>.from(state.surveyAnswers);
    updatedAnswers[questionId] = answer;
    
    state = state.copyWith(
      surveyAnswers: updatedAnswers,
      error: null,
    );
  }

  /// 다음 단계로 이동
  void nextStep() {
    if (state.isCurrentStepComplete) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        error: null,
      );
    }
  }

  /// 이전 단계로 이동
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        error: null,
      );
    }
  }

  /// 특정 단계로 이동
  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      state = state.copyWith(
        currentStep: step,
        error: null,
      );
    }
  }

  /// 로딩 상태 설정
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// 에러 설정
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  /// 상태 초기화
  void reset() {
    state = const ProfileSetupState();
  }

  /// UserEntity로 변환
  UserEntity? toUserEntity(String userId) {
    if (!state.isComplete) return null;

    return UserEntity(
      uid: userId,
      nickname: state.nickname!,
      emotionTags: state.emotionTags,
      preferredTime: state.preferredTime!,
      empathyScore: _calculateEmpathyScore(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 공감 성향 점수 계산
  double _calculateEmpathyScore() {
    if (state.surveyAnswers.isEmpty) return 3.0; // 기본값

    int positiveAnswers = 0;
    int totalAnswers = state.surveyAnswers.length;

    // 설문 답변을 기반으로 점수 계산
    for (final answer in state.surveyAnswers.values) {
      if (answer == '그렇다') {
        positiveAnswers++;
      }
    }

    // 1-5점 척도로 변환
    return (positiveAnswers / totalAnswers * 4) + 1;
  }
} 