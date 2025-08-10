import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/data.dart';
import '../../domain/repositories/matching_repository.dart';
import '../../domain/repositories/chat_repository.dart';

part 'service_locator.g.dart';

/// Firebase Auth 인스턴스 제공
@riverpod
firebase_auth.FirebaseAuth firebaseAuthProvider(Ref ref) {
  return firebase_auth.FirebaseAuth.instance;
}

/// Firestore 인스턴스 제공
@riverpod
FirebaseFirestore firestoreProvider(Ref ref) {
  return FirebaseFirestore.instance;
}

/// Firebase Messaging 인스턴스 제공
@riverpod
FirebaseMessaging firebaseMessaging(Ref ref) {
  return FirebaseMessaging.instance;
}

/// 현재 사용자 상태 제공
@riverpod
Stream<firebase_auth.User?> currentUserProvider(Ref ref) {
  final auth = firebase_auth.FirebaseAuth.instance;
  return auth.authStateChanges();
}

/// 사용자 인증 상태 제공 (bool)
@riverpod
Stream<bool> isAuthenticated(Ref ref) {
  final auth = firebase_auth.FirebaseAuth.instance;
  return auth.authStateChanges().map((user) => user != null);
}

/// 사용자 UID 제공
@riverpod
String? currentUserId(Ref ref) {
  final auth = firebase_auth.FirebaseAuth.instance;
  return auth.currentUser?.uid;
}

/// 매칭 Repository 제공
@riverpod
MatchingRepository matchingRepository(Ref ref) {
  final firestore = FirebaseFirestore.instance;
  final matchingDataSource = FirestoreMatchingDataSource(firestore);
  return MatchingRepositoryImpl(matchingDataSource);
}

/// 채팅 Repository 제공
@riverpod
ChatRepository chatRepository(Ref ref) {
  final firestore = FirebaseFirestore.instance;
  final chatDataSource = FirestoreChatDataSource(firestore);
  return ChatRepositoryImpl(chatDataSource);
} 