import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/matching_model.dart';

/// 매칭 관련 Firestore 데이터소스
/// 
/// 매칭 데이터의 CRUD 작업을 담당합니다.
class FirestoreMatchingDataSource {
  const FirestoreMatchingDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  /// 매칭 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _matchingsCollection =>
      _firestore.collection('matchings');

  /// 오늘의 매칭을 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// 
  /// Returns: 오늘의 매칭 정보 (없으면 null)
  Future<MatchingModel?> getTodayMatching(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final query = _matchingsCollection
          .where('status', isEqualTo: 'active')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
          .where(Filter.or(
            Filter('userAId', isEqualTo: userId),
            Filter('userBId', isEqualTo: userId),
          ));

      final snapshot = await query.get();
      
      if (snapshot.docs.isEmpty) return null;
      
      // 가장 최근 매칭 반환
      final doc = snapshot.docs.first;
      return MatchingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('오늘의 매칭 조회 실패: $e');
    }
  }

  /// 새로운 매칭을 생성합니다.
  /// 
  /// [userAId] 첫 번째 사용자 ID
  /// [userBId] 두 번째 사용자 ID
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns: 생성된 매칭 정보
  Future<MatchingModel> createMatching({
    required String userAId,
    required String userBId,
    required String chatRoomId,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      final matchingData = {
        'userAId': userAId,
        'userBId': userBId,
        'chatRoomId': chatRoomId,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'status': 'active',
      };

      final docRef = await _matchingsCollection.add(matchingData);
      final doc = await docRef.get();
      
      return MatchingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('매칭 생성 실패: $e');
    }
  }

  /// 매칭을 취소합니다.
  /// 
  /// [matchingId] 매칭 ID
  /// [userId] 매칭을 취소하는 사용자 ID
  /// 
  /// Returns: 취소 성공 여부
  Future<bool> cancelMatching({
    required String matchingId,
    required String userId,
  }) async {
    try {
      final docRef = _matchingsCollection.doc(matchingId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('매칭을 찾을 수 없습니다.');
      }

      final data = doc.data()!;
      final userAId = data['userAId'] as String;
      final userBId = data['userBId'] as String;

      // 매칭 참가자만 취소 가능
      if (userId != userAId && userId != userBId) {
        throw Exception('매칭을 취소할 권한이 없습니다.');
      }

      await docRef.update({
        'status': 'cancelled',
        'cancelledAt': Timestamp.fromDate(DateTime.now()),
        'cancelledBy': userId,
      });

      return true;
    } catch (e) {
      throw Exception('매칭 취소 실패: $e');
    }
  }

  /// 매칭 이력을 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// [limit] 조회할 매칭 수
  /// 
  /// Returns: 매칭 이력 목록
  Future<List<MatchingModel>> getMatchingHistory({
    required String userId,
    int limit = 20,
  }) async {
    try {
      final query = _matchingsCollection
          .where(Filter.or(
            Filter('userAId', isEqualTo: userId),
            Filter('userBId', isEqualTo: userId),
          ))
          .orderBy('createdAt', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => MatchingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('매칭 이력 조회 실패: $e');
    }
  }

  /// 만료된 매칭들을 업데이트합니다.
  /// 
  /// Returns: 업데이트된 매칭 수
  Future<int> updateExpiredMatchings() async {
    try {
      final now = DateTime.now();
      
      final query = _matchingsCollection
          .where('status', isEqualTo: 'active')
          .where('expiresAt', isLessThan: Timestamp.fromDate(now));

      final snapshot = await query.get();
      
      final batch = _firestore.batch();
      int updatedCount = 0;

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': 'expired',
          'expiredAt': Timestamp.fromDate(now),
        });
        updatedCount++;
      }

      if (updatedCount > 0) {
        await batch.commit();
      }

      return updatedCount;
    } catch (e) {
      throw Exception('만료된 매칭 업데이트 실패: $e');
    }
  }

  /// 특정 사용자와의 매칭 이력이 있는지 확인합니다.
  /// 
  /// [userId] 현재 사용자 ID
  /// [otherUserId] 상대 사용자 ID
  /// [days] 확인할 일수 (기본값: 7일)
  /// 
  /// Returns: 매칭 이력 존재 여부
  Future<bool> hasRecentMatching({
    required String userId,
    required String otherUserId,
    int days = 7,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final query = _matchingsCollection
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffDate))
          .where(Filter.or(
            Filter.and(
                          Filter('userAId', isEqualTo: userId),
            Filter('userBId', isEqualTo: otherUserId),
          ),
          Filter.and(
            Filter('userAId', isEqualTo: otherUserId),
            Filter('userBId', isEqualTo: userId),
            ),
          ));

      final snapshot = await query.get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('최근 매칭 이력 확인 실패: $e');
    }
  }

  /// 매칭 요청을 처리합니다.
  /// 
  /// [uid] 사용자 ID
  Future<void> requestMatching(String uid) async {
    try {
      // TODO: 매칭 요청 로직 구현
      // 현재는 단순히 로그만 출력
      print('매칭 요청: $uid');
    } catch (e) {
      throw Exception('매칭 요청 실패: $e');
    }
  }

  /// 사용자의 매칭 상태를 확인합니다.
  /// 
  /// [userId] 사용자 ID
  /// 
  /// Returns: 매칭된 상태 여부
  Future<bool> isMatched(String userId) async {
    try {
      final query = _matchingsCollection
          .where('status', isEqualTo: 'active')
          .where(Filter.or(
            Filter('userAId', isEqualTo: userId),
            Filter('userBId', isEqualTo: userId),
          ));

      final snapshot = await query.get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('매칭 상태 확인 실패: $e');
    }
  }
} 