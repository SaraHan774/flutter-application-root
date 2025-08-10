import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/matching_entity.dart';
import '../../domain/repositories/matching_repository.dart';
import '../datasources/firestore_matching_datasource.dart';

part 'matching_repository_impl.g.dart';

/// 매칭 Repository 구현체
/// 
/// 매칭 관련 비즈니스 로직을 처리합니다.
class MatchingRepositoryImpl implements MatchingRepository {
  const MatchingRepositoryImpl(this._matchingDataSource);

  final FirestoreMatchingDataSource _matchingDataSource;

  @override
  Future<MatchingEntity?> getTodayMatching(String userId) async {
    try {
      final matching = await _matchingDataSource.getTodayMatching(userId);
      return matching?.toEntity();
    } catch (e) {
      throw Exception('오늘의 매칭 조회 실패: $e');
    }
  }

  @override
  Future<MatchingEntity> createMatching({
    required String userAId,
    required String userBId,
  }) async {
    try {
      // 채팅방 ID 생성 (매칭 ID와 동일하게 사용)
      final chatRoomId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
      
      final matching = await _matchingDataSource.createMatching(
        userAId: userAId,
        userBId: userBId,
        chatRoomId: chatRoomId,
      );
      
      return matching.toEntity();
    } catch (e) {
      throw Exception('매칭 생성 실패: $e');
    }
  }

  @override
  Future<bool> cancelMatching({
    required String matchingId,
    required String userId,
  }) async {
    try {
      return await _matchingDataSource.cancelMatching(
        matchingId: matchingId,
        userId: userId,
      );
    } catch (e) {
      throw Exception('매칭 취소 실패: $e');
    }
  }

  @override
  Future<List<MatchingEntity>> getMatchingHistory({
    required String userId,
    int limit = 20,
  }) async {
    try {
      final matchings = await _matchingDataSource.getMatchingHistory(
        userId: userId,
        limit: limit,
      );
      
      return matchings.map((matching) => matching.toEntity()).toList();
    } catch (e) {
      throw Exception('매칭 이력 조회 실패: $e');
    }
  }

  @override
  Future<void> requestMatching(String uid) async {
    try {
      await _matchingDataSource.requestMatching(uid);
    } catch (e) {
      throw Exception('매칭 요청 실패: $e');
    }
  }

  @override
  Future<bool> isMatched(String userId) async {
    try {
      return await _matchingDataSource.isMatched(userId);
    } catch (e) {
      throw Exception('매칭 상태 확인 실패: $e');
    }
  }

  @override
  Future<bool> hasRecentMatching({
    required String userId,
    required String otherUserId,
    int days = 7,
  }) async {
    try {
      return await _matchingDataSource.hasRecentMatching(
        userId: userId,
        otherUserId: otherUserId,
        days: days,
      );
    } catch (e) {
      throw Exception('최근 매칭 이력 확인 실패: $e');
    }
  }

  @override
  Future<int> updateExpiredMatchings() async {
    try {
      return await _matchingDataSource.updateExpiredMatchings();
    } catch (e) {
      throw Exception('만료된 매칭 업데이트 실패: $e');
    }
  }
}

/// MatchingRepositoryImpl Provider
@riverpod
MatchingRepositoryImpl matchingRepositoryImpl(MatchingRepositoryImplRef ref) {
  final firestore = FirebaseFirestore.instance;
  final matchingDataSource = FirestoreMatchingDataSource(firestore);
  return MatchingRepositoryImpl(matchingDataSource);
}

/// MatchingRepository Provider
@riverpod
MatchingRepository matchingRepository(MatchingRepositoryRef ref) {
  return ref.watch(matchingRepositoryImplProvider);
} 