import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/matching_entity.dart';
import '../../domain/usecases/matching/get_today_matching.dart';
import '../../domain/usecases/matching/create_matching.dart';
import '../../domain/usecases/matching/cancel_matching.dart';
import '../../domain/usecases/matching/get_matching_history.dart';
import '../../data/repositories/matching_repository_impl.dart';

part 'matching_provider.g.dart';

/// 매칭 상태 관리 Provider
/// 
/// 매칭 관련 상태와 비즈니스 로직을 관리합니다.
@riverpod
class MatchingNotifier extends _$MatchingNotifier {
  @override
  Future<MatchingEntity?> build() async {
    // 초기 상태는 null (매칭 없음)
    return null;
  }

  /// 오늘의 매칭을 조회합니다.
  /// 
  /// [userId] 사용자 ID
  Future<void> loadTodayMatching(String userId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(matchingRepositoryProvider);
      final useCase = GetTodayMatchingUseCase(repository);
      final result = await useCase(userId);
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (matching) => state = AsyncValue.data(matching),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 새로운 매칭을 생성합니다.
  /// 
  /// [userAId] 첫 번째 사용자 ID
  /// [userBId] 두 번째 사용자 ID
  Future<void> createMatching({
    required String userAId,
    required String userBId,
  }) async {
    try {
      final repository = ref.read(matchingRepositoryProvider);
      final useCase = CreateMatchingUseCase(repository);
      final result = await useCase(
        userAId: userAId,
        userBId: userBId,
      );
      
      result.fold(
        (failure) => throw failure,
        (matching) => state = AsyncValue.data(matching),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 매칭을 취소합니다.
  /// 
  /// [matchingId] 매칭 ID
  /// [userId] 매칭을 취소하는 사용자 ID
  Future<void> cancelMatching({
    required String matchingId,
    required String userId,
  }) async {
    try {
      final repository = ref.read(matchingRepositoryProvider);
      final useCase = CancelMatchingUseCase(repository);
      final result = await useCase(
        matchingId: matchingId,
        userId: userId,
      );
      
      result.fold(
        (failure) => throw failure,
        (success) {
          if (success) {
            // 매칭 취소 성공 시 상태를 null로 변경
            state = const AsyncValue.data(null);
          }
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 매칭을 새로고침합니다.
  /// 
  /// [userId] 사용자 ID
  Future<void> refreshMatching(String userId) async {
    await loadTodayMatching(userId);
  }

  /// 매칭 상태를 초기화합니다.
  void clearMatching() {
    state = const AsyncValue.data(null);
  }
}

/// 매칭 이력 Provider
@riverpod
class MatchingHistoryNotifier extends _$MatchingHistoryNotifier {
  @override
  Future<List<MatchingEntity>> build() async {
    return [];
  }

  /// 매칭 이력을 로드합니다.
  /// 
  /// [userId] 사용자 ID
  /// [limit] 조회할 매칭 수
  Future<void> loadMatchingHistory({
    required String userId,
    int limit = 20,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(matchingRepositoryProvider);
      final useCase = GetMatchingHistoryUseCase(repository);
      final result = await useCase(
        userId: userId,
        limit: limit,
      );
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (matchings) => state = AsyncValue.data(matchings),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 매칭 이력을 새로고침합니다.
  /// 
  /// [userId] 사용자 ID
  /// [limit] 조회할 매칭 수
  Future<void> refreshHistory({
    required String userId,
    int limit = 20,
  }) async {
    await loadMatchingHistory(userId: userId, limit: limit);
  }

  /// 매칭 이력을 초기화합니다.
  void clearHistory() {
    state = const AsyncValue.data([]);
  }
}

/// 매칭 상태 Provider (간단한 상태만)
@riverpod
class MatchingStatusNotifier extends _$MatchingStatusNotifier {
  @override
  MatchingStatus build() {
    return const MatchingStatus();
  }

  /// 매칭 상태를 업데이트합니다.
  void updateStatus({
    bool? isLoading,
    bool? hasMatching,
    String? errorMessage,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      hasMatching: hasMatching,
      errorMessage: errorMessage,
    );
  }

  /// 로딩 상태를 설정합니다.
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// 매칭 존재 여부를 설정합니다.
  void setHasMatching(bool hasMatching) {
    state = state.copyWith(hasMatching: hasMatching);
  }

  /// 에러 메시지를 설정합니다.
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// 상태를 초기화합니다.
  void reset() {
    state = const MatchingStatus();
  }
}

/// 매칭 상태 데이터 클래스
class MatchingStatus {
  const MatchingStatus({
    this.isLoading = false,
    this.hasMatching = false,
    this.errorMessage,
  });

  final bool isLoading;
  final bool hasMatching;
  final String? errorMessage;

  MatchingStatus copyWith({
    bool? isLoading,
    bool? hasMatching,
    String? errorMessage,
  }) {
    return MatchingStatus(
      isLoading: isLoading ?? this.isLoading,
      hasMatching: hasMatching ?? this.hasMatching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchingStatus &&
        other.isLoading == isLoading &&
        other.hasMatching == hasMatching &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, hasMatching, errorMessage);
  }

  @override
  String toString() {
    return 'MatchingStatus(isLoading: $isLoading, hasMatching: $hasMatching, errorMessage: $errorMessage)';
  }
} 