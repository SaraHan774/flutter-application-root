import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_selection_provider.g.dart';

/// 감정 선택 상태 모델
class EmotionSelectionState {
  final Set<String> selectedEmotions;
  final List<String> availableEmotions;
  final int minSelection;
  final int maxSelection;
  final bool isLoading;
  final String? error;

  const EmotionSelectionState({
    this.selectedEmotions = const {},
    this.availableEmotions = const [],
    this.minSelection = 3,
    this.maxSelection = 5,
    this.isLoading = false,
    this.error,
  });

  EmotionSelectionState copyWith({
    Set<String>? selectedEmotions,
    List<String>? availableEmotions,
    int? minSelection,
    int? maxSelection,
    bool? isLoading,
    String? error,
  }) {
    return EmotionSelectionState(
      selectedEmotions: selectedEmotions ?? this.selectedEmotions,
      availableEmotions: availableEmotions ?? this.availableEmotions,
      minSelection: minSelection ?? this.minSelection,
      maxSelection: maxSelection ?? this.maxSelection,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 최소 선택 개수 충족 여부
  bool get isMinSelectionMet {
    return selectedEmotions.length >= minSelection;
  }

  /// 최대 선택 개수 도달 여부
  bool get isMaxSelectionReached {
    return selectedEmotions.length >= maxSelection;
  }

  /// 선택 가능한 감정 개수
  int get remainingSelections {
    return maxSelection - selectedEmotions.length;
  }

  /// 선택 완료 여부
  bool get isComplete {
    return isMinSelectionMet;
  }
}

/// 감정 선택 상태 관리 Provider
@riverpod
class EmotionSelectionNotifier extends _$EmotionSelectionNotifier {
  @override
  EmotionSelectionState build() {
    // 기본 감정 키워드 목록
    const defaultEmotions = [
      '고요함',
      '피곤해',
      '위로가필요해',
      '무기력함',
      '외로움',
      '불안함',
      '기쁨',
      '평온함',
      '설렘',
      '그리움',
      '감사함',
      '희망',
      '우울함',
      '스트레스',
      '짜증',
      '답답함',
      '허전함',
      '따뜻함',
      '편안함',
      '행복함',
    ];

    return EmotionSelectionState(
      availableEmotions: defaultEmotions,
    );
  }

  /// 감정 키워드 선택/해제
  void toggleEmotion(String emotion) {
    final currentSelected = Set<String>.from(state.selectedEmotions);
    
    if (currentSelected.contains(emotion)) {
      // 선택 해제
      currentSelected.remove(emotion);
    } else {
      // 선택 추가 (최대 개수 제한 확인)
      if (currentSelected.length < state.maxSelection) {
        currentSelected.add(emotion);
      }
    }

    state = state.copyWith(
      selectedEmotions: currentSelected,
      error: null,
    );
  }

  /// 감정 키워드 선택
  void selectEmotion(String emotion) {
    if (state.selectedEmotions.contains(emotion)) return;
    
    if (state.selectedEmotions.length >= state.maxSelection) {
      state = state.copyWith(
        error: '최대 ${state.maxSelection}개까지만 선택할 수 있습니다.',
      );
      return;
    }

    final updatedSelected = Set<String>.from(state.selectedEmotions);
    updatedSelected.add(emotion);

    state = state.copyWith(
      selectedEmotions: updatedSelected,
      error: null,
    );
  }

  /// 감정 키워드 해제
  void deselectEmotion(String emotion) {
    final updatedSelected = Set<String>.from(state.selectedEmotions);
    updatedSelected.remove(emotion);

    state = state.copyWith(
      selectedEmotions: updatedSelected,
      error: null,
    );
  }

  /// 모든 감정 키워드 선택 해제
  void clearAllSelections() {
    state = state.copyWith(
      selectedEmotions: {},
      error: null,
    );
  }

  /// 선택된 감정 키워드 목록 반환
  List<String> get selectedEmotionsList {
    return state.selectedEmotions.toList();
  }

  /// 사용 가능한 감정 키워드 목록 반환 (선택되지 않은 것들)
  List<String> get availableEmotionsList {
    return state.availableEmotions
        .where((emotion) => !state.selectedEmotions.contains(emotion))
        .toList();
  }

  /// 로딩 상태 설정
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// 에러 설정
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 상태 초기화
  void reset() {
    state = EmotionSelectionState(
      availableEmotions: state.availableEmotions,
    );
  }

  /// 감정 키워드 목록 업데이트
  void updateAvailableEmotions(List<String> emotions) {
    state = state.copyWith(
      availableEmotions: emotions,
      error: null,
    );
  }

  /// 선택 제한 설정
  void updateSelectionLimits({int? minSelection, int? maxSelection}) {
    state = state.copyWith(
      minSelection: minSelection ?? state.minSelection,
      maxSelection: maxSelection ?? state.maxSelection,
      error: null,
    );
  }
} 