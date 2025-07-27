import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/data.dart';
import '../../domain/repositories/matching_repository.dart';
import '../../domain/repositories/chat_repository.dart';

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
  return ref.watch(currentUserProvider.stream).map((user) => user != null);
}

/// 사용자 UID 제공
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser?.uid;
}

/// 매칭 Repository 제공
@riverpod
MatchingRepository getMatchingRepository(GetMatchingRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  final matchingDataSource = FirestoreMatchingDataSource(firestore);
  return MatchingRepositoryImpl(matchingDataSource);
}

/// 채팅 Repository 제공
@riverpod
ChatRepository getChatRepository(GetChatRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  final chatDataSource = FirestoreChatDataSource(firestore);
  return ChatRepositoryImpl(chatDataSource);
} 