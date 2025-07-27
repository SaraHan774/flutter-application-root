import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/core.dart';

/// Firebase Auth 데이터 소스
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  /// 전화번호 인증 시작 (SMS 전송)
  Future<String> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      AppLogger.auth('sendPhoneVerificationCode', userId: phoneNumber);
      
      // Completer를 사용하여 verificationId를 기다림
      final completer = Completer<String>();
      
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // 자동 인증 완료 (Android에서만 발생)
          AppLogger.auth('verificationCompleted', userId: phoneNumber);
        },
        verificationFailed: (FirebaseAuthException e) {
          AppLogger.auth('verificationFailed', userId: phoneNumber, error: e.message);
          if (!completer.isCompleted) {
            completer.completeError(ErrorHandler.handleAuthError(e));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          AppLogger.auth('codeSent', userId: phoneNumber);
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          AppLogger.auth('codeAutoRetrievalTimeout', userId: phoneNumber);
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        timeout: const Duration(seconds: 60),
      );

      // verificationId를 기다림
      return await completer.future;
    } catch (e) {
      AppLogger.error('sendPhoneVerificationCode failed', e);
      rethrow;
    }
  }

  /// 인증번호 확인 및 로그인
  Future<User> verifyPhoneCode({
    required String phoneNumber,
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      AppLogger.auth('verifyPhoneCode', userId: phoneNumber);
      
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) {
        throw const AuthFailure('인증에 실패했습니다.');
      }

      AppLogger.auth('verifyPhoneCode success', userId: user.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      AppLogger.auth('verifyPhoneCode failed', userId: phoneNumber, error: e.message);
      throw ErrorHandler.handleAuthError(e);
    } catch (e) {
      AppLogger.error('verifyPhoneCode failed', e);
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      AppLogger.auth('signOut');
      await _firebaseAuth.signOut();
      AppLogger.auth('signOut success');
    } catch (e) {
      AppLogger.error('signOut failed', e);
      rethrow;
    }
  }

  /// 현재 로그인된 유저 반환
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// 인증 상태 스트림
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }
} 