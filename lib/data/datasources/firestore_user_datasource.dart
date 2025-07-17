import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/core.dart';
import '../models/user_model.dart';

/// Firestore 사용자 데이터 소스
class FirestoreUserDataSource {
  final FirebaseFirestore _firestore;

  FirestoreUserDataSource(this._firestore);

  /// UID로 사용자 프로필 조회
  Future<UserModel?> getUserById(String uid) async {
    try {
      AppLogger.database('getUserById', FirebaseConstants.usersCollection, documentId: uid);
      
      final doc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        AppLogger.database('getUserById - document not found', FirebaseConstants.usersCollection, documentId: uid);
        return null;
      }

      final userModel = UserModel.fromMap(doc.data()!, uid);
      AppLogger.database('getUserById success', FirebaseConstants.usersCollection, documentId: uid);
      
      return userModel;
    } on FirebaseException catch (e) {
      AppLogger.database('getUserById failed', FirebaseConstants.usersCollection, documentId: uid, error: e);
      throw ErrorHandler.handleFirestoreError(e);
    } catch (e) {
      AppLogger.error('getUserById failed', e);
      rethrow;
    }
  }

  /// 닉네임 중복 검사
  Future<bool> isNicknameDuplicate(String nickname) async {
    try {
      AppLogger.database('isNicknameDuplicate', FirebaseConstants.usersCollection);
      
      final query = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FirebaseConstants.nicknameField, isEqualTo: nickname)
          .limit(1)
          .get();

      final isDuplicate = query.docs.isNotEmpty;
      AppLogger.database('isNicknameDuplicate result: $isDuplicate', FirebaseConstants.usersCollection);
      
      return isDuplicate;
    } on FirebaseException catch (e) {
      AppLogger.database('isNicknameDuplicate failed', FirebaseConstants.usersCollection, error: e);
      throw ErrorHandler.handleFirestoreError(e);
    } catch (e) {
      AppLogger.error('isNicknameDuplicate failed', e);
      rethrow;
    }
  }

  /// 프로필 생성
  Future<void> createUserProfile(UserModel user) async {
    try {
      AppLogger.database('createUserProfile', FirebaseConstants.usersCollection, documentId: user.uid);
      
      final now = DateTime.now();
      final userData = user.toMap()
        ..addAll({
          FirebaseConstants.createdAtField: now.toIso8601String(),
          FirebaseConstants.updatedAtField: now.toIso8601String(),
        });

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(userData);

      AppLogger.database('createUserProfile success', FirebaseConstants.usersCollection, documentId: user.uid);
    } on FirebaseException catch (e) {
      AppLogger.database('createUserProfile failed', FirebaseConstants.usersCollection, documentId: user.uid, error: e);
      throw ErrorHandler.handleFirestoreError(e);
    } catch (e) {
      AppLogger.error('createUserProfile failed', e);
      rethrow;
    }
  }

  /// 프로필 업데이트
  Future<void> updateUserProfile(UserModel user) async {
    try {
      AppLogger.database('updateUserProfile', FirebaseConstants.usersCollection, documentId: user.uid);
      
      final userData = user.toMap()
        ..addAll({
          FirebaseConstants.updatedAtField: DateTime.now().toIso8601String(),
        });

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .update(userData);

      AppLogger.database('updateUserProfile success', collection: FirebaseConstants.usersCollection, documentId: user.uid);
    } on FirebaseException catch (e) {
      AppLogger.database('updateUserProfile failed', FirebaseConstants.usersCollection, documentId: user.uid, error: e);
      throw ErrorHandler.handleFirestoreError(e);
    } catch (e) {
      AppLogger.error('updateUserProfile failed', e);
      rethrow;
    }
  }
} 