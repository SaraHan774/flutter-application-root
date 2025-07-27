import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/matching_entity.dart';
import '../../domain/usecases/matching/get_today_matching.dart';
import '../../domain/usecases/matching/create_matching.dart';
import '../../domain/usecases/matching/cancel_matching.dart';
import '../../domain/usecases/matching/get_matching_history.dart';
import '../../core/di/service_locator.dart';

/// 매칭 상태
class MatchingState {
  final MatchingEntity? todayMatching;
  final List<MatchingEntity> matchingHistory;
  final bool isLoading;
  final String? error;

  const MatchingState({
    this.todayMatching,
    this.matchingHistory = const [],
    this.isLoading = false,
    this.error,
  });

  MatchingState copyWith({
    MatchingEntity? todayMatching,
    List<MatchingEntity>? matchingHistory,
    bool? isLoading,
    String? error,
  }) {
    return MatchingState(
      todayMatching: todayMatching ?? this.todayMatching,
      matchingHistory: matchingHistory ?? this.matchingHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 매칭 상태 관리 Notifier
class MatchingNotifier extends StateNotifier<MatchingState> {
  final GetTodayMatchingUseCase _getTodayMatchingUseCase;
  final CreateMatchingUseCase _createMatchingUseCase;
  final CancelMatchingUseCase _cancelMatchingUseCase;
  final GetMatchingHistoryUseCase _getMatchingHistoryUseCase;

  MatchingNotifier(
    this._getTodayMatchingUseCase,
    this._createMatchingUseCase,
    this._cancelMatchingUseCase,
    this._getMatchingHistoryUseCase,
  ) : super(const MatchingState());

  /// 오늘의 매칭 조회
  Future<void> getTodayMatching(String uid) async {
    print('[한담] [MATCHING] Starting to get today matching for user: $uid');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final matching = await _getTodayMatchingUseCase(uid);
      print('[한담] [MATCHING] Got matching result: $matching');
      state = state.copyWith(
        todayMatching: matching,
        isLoading: false,
      );
      print('[한담] [MATCHING] State updated - isLoading: false');
    } catch (e) {
      print('[한담] [MATCHING] Error occurred: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 매칭 생성
  Future<void> createMatching({
    required String userA,
    required String userB,
    required String chatRoomId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final matching = await _createMatchingUseCase(
        userA: userA,
        userB: userB,
        chatRoomId: chatRoomId,
      );
      state = state.copyWith(
        todayMatching: matching,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 매칭 취소
  Future<void> cancelMatching(String matchingId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _cancelMatchingUseCase(matchingId);
      state = state.copyWith(
        todayMatching: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 매칭 이력 조회
  Future<void> getMatchingHistory({
    required String uid,
    int limit = 20,
    DateTime? beforeDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final history = await _getMatchingHistoryUseCase(
        uid: uid,
        limit: limit,
        beforeDate: beforeDate,
      );
      state = state.copyWith(
        matchingHistory: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 로딩 상태 초기화
  void clearLoading() {
    state = state.copyWith(isLoading: false);
  }
}

/// 매칭 Provider
final matchingProvider = StateNotifierProvider<MatchingNotifier, MatchingState>((ref) {
  final matchingRepository = ref.watch(getMatchingRepositoryProvider);
  return MatchingNotifier(
    GetTodayMatchingUseCase(matchingRepository),
    CreateMatchingUseCase(matchingRepository),
    CancelMatchingUseCase(matchingRepository),
    GetMatchingHistoryUseCase(matchingRepository),
  );
}); 