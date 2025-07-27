import '../../domain/repositories/matching_repository.dart';
import '../../domain/entities/matching_entity.dart';
import '../datasources/firestore_matching_datasource.dart';
import '../../core/error/error_handler.dart';

/// 매칭 Repository 구현체
class MatchingRepositoryImpl implements MatchingRepository {
  final FirestoreMatchingDataSource _matchingDataSource;

  MatchingRepositoryImpl(this._matchingDataSource);

  @override
  Future<MatchingEntity?> getTodayMatching(String uid) async {
    try {
      return await _matchingDataSource.getTodayMatching(uid);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<void> requestMatching(String uid) async {
    try {
      await _matchingDataSource.requestMatching(uid);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<MatchingEntity> createMatching({
    required String userA,
    required String userB,
    required String chatRoomId,
  }) async {
    try {
      return await _matchingDataSource.createMatching(
        userA: userA,
        userB: userB,
        chatRoomId: chatRoomId,
      );
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<void> cancelMatching(String matchingId) async {
    try {
      await _matchingDataSource.cancelMatching(matchingId);
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }

  @override
  Future<List<MatchingEntity>> getMatchingHistory({
    required String uid,
    int limit = 20,
    DateTime? beforeDate,
  }) async {
    try {
      return await _matchingDataSource.getMatchingHistory(
        uid: uid,
        limit: limit,
        beforeDate: beforeDate,
      );
    } catch (e) {
      if (e is Exception) {
        throw ErrorHandler.handleGenericError(e);
      } else {
        throw ErrorHandler.handleNetworkError(e);
      }
    }
  }
} 