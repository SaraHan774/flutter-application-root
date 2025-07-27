import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matching_model.dart';
import '../../domain/entities/matching_entity.dart';

/// 매칭 Firestore 데이터소스
class FirestoreMatchingDataSource {
  final FirebaseFirestore _firestore;

  FirestoreMatchingDataSource(this._firestore);

  /// 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _matchingsCollection =>
      _firestore.collection('matchings');

  /// 오늘의 매칭 조회
  Future<MatchingEntity?> getTodayMatching(String uid) async {
    try {
      // TODO: 실제 Firestore 쿼리 구현 (현재는 임시로 null 반환)
      // Firestore에 실제 데이터가 없으므로 null을 반환하여 "매칭 없음" 상태 표시
      
      // 개발용: 테스트를 위해 가끔 매칭이 있다고 가정 (주석 처리)
      // if (uid.endsWith('1')) {
      //   return MatchingModel(
      //     matchingId: 'test_matching_${DateTime.now().millisecondsSinceEpoch}',
      //     userA: uid,
      //     userB: 'test_user_b',
      //     chatRoomId: 'test_chat_room_${DateTime.now().millisecondsSinceEpoch}',
      //     createdAt: DateTime.now(),
      //     status: 'active',
      //   );
      // }
      
      // 즉시 null 반환 (로딩 상태 해제를 위해)
      await Future.delayed(const Duration(milliseconds: 100)); // 최소 로딩 시간
      return null;
    } catch (e) {
      throw Exception('Failed to get today matching: $e');
    }
  }

  /// 매칭 생성
  Future<MatchingEntity> createMatching({
    required String userA,
    required String userB,
    required String chatRoomId,
  }) async {
    try {
      final docRef = _matchingsCollection.doc();
      final matching = MatchingModel(
        matchingId: docRef.id,
        userA: userA,
        userB: userB,
        chatRoomId: chatRoomId,
        createdAt: DateTime.now(),
        status: 'active',
      );

      await docRef.set(matching.toJson());
      return matching;
    } catch (e) {
      throw Exception('Failed to create matching: $e');
    }
  }

  /// 매칭 취소
  Future<void> cancelMatching(String matchingId) async {
    try {
      await _matchingsCollection.doc(matchingId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      throw Exception('Failed to cancel matching: $e');
    }
  }

  /// 매칭 이력 조회
  Future<List<MatchingEntity>> getMatchingHistory({
    required String uid,
    int limit = 20,
    DateTime? beforeDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _matchingsCollection
          .where('userA', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (beforeDate != null) {
        query = query.where('createdAt', isLessThan: beforeDate.toIso8601String());
      }

      final querySnapshot = await query.get();
      final matchings = querySnapshot.docs
          .map((doc) => MatchingModel.fromJson(doc.data(), doc.id))
          .toList();

      // userB로도 검색
      Query<Map<String, dynamic>> query2 = _matchingsCollection
          .where('userB', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (beforeDate != null) {
        query2 = query2.where('createdAt', isLessThan: beforeDate.toIso8601String());
      }

      final querySnapshot2 = await query2.get();
      final matchings2 = querySnapshot2.docs
          .map((doc) => MatchingModel.fromJson(doc.data(), doc.id))
          .toList();

      // 두 결과를 합치고 중복 제거
      final allMatchings = [...matchings, ...matchings2];
      allMatchings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allMatchings.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get matching history: $e');
    }
  }

  /// 매칭 요청 (서버 트리거용)
  Future<void> requestMatching(String uid) async {
    try {
      // 매칭 요청을 위한 임시 문서 생성
      // 실제 매칭 로직은 Cloud Functions에서 처리
      await _firestore.collection('matchingRequests').add({
        'userId': uid,
        'requestedAt': DateTime.now().toIso8601String(),
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to request matching: $e');
    }
  }
} 