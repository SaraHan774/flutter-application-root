import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'service_locator.g.dart';

/// Firebase Auth 인스턴스 제공
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

/// Firestore 인스턴스 제공
@riverpod
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

/// Firebase Messaging 인스턴스 제공
@riverpod
FirebaseMessaging firebaseMessaging(FirebaseMessagingRef ref) {
  return FirebaseMessaging.instance;
}

/// 현재 사용자 상태 제공
@riverpod
Stream<User?> currentUser(CurrentUserRef ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
}

/// 사용자 인증 상태 제공 (bool)
@riverpod
Stream<bool> isAuthenticated(IsAuthenticatedRef ref) {
  final userStream = ref.watch(currentUserProvider);
  return userStream.map((user) => user != null);
}

/// 사용자 UID 제공
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser?.uid;
} 