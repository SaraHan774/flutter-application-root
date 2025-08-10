// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_locator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthProviderHash() =>
    r'f4ad6fac2a9657135452f7999c3808446dbb1cf0';

/// Firebase Auth 인스턴스 제공
///
/// Copied from [firebaseAuthProvider].
@ProviderFor(firebaseAuthProvider)
final firebaseAuthProviderProvider =
    AutoDisposeProvider<firebase_auth.FirebaseAuth>.internal(
  firebaseAuthProvider,
  name: r'firebaseAuthProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthProviderRef
    = AutoDisposeProviderRef<firebase_auth.FirebaseAuth>;
String _$firestoreProviderHash() => r'22ce7f65aeed7dd86de25c1aebb3e206b491ceae';

/// Firestore 인스턴스 제공
///
/// Copied from [firestoreProvider].
@ProviderFor(firestoreProvider)
final firestoreProviderProvider =
    AutoDisposeProvider<FirebaseFirestore>.internal(
  firestoreProvider,
  name: r'firestoreProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firestoreProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreProviderRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$firebaseMessagingHash() => r'6abf9bf6d98c4ba311760139587b2995df4c1508';

/// Firebase Messaging 인스턴스 제공
///
/// Copied from [firebaseMessaging].
@ProviderFor(firebaseMessaging)
final firebaseMessagingProvider =
    AutoDisposeProvider<FirebaseMessaging>.internal(
  firebaseMessaging,
  name: r'firebaseMessagingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseMessagingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseMessagingRef = AutoDisposeProviderRef<FirebaseMessaging>;
String _$currentUserProviderHash() =>
    r'82c9434f577dbb82248765b4488d4a4df76dc993';

/// 현재 사용자 상태 제공
///
/// Copied from [currentUserProvider].
@ProviderFor(currentUserProvider)
final currentUserProviderProvider =
    AutoDisposeStreamProvider<firebase_auth.User?>.internal(
  currentUserProvider,
  name: r'currentUserProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProviderRef
    = AutoDisposeStreamProviderRef<firebase_auth.User?>;
String _$isAuthenticatedHash() => r'7081def002a28495d9c251a2d93c64c87d5ad072';

/// 사용자 인증 상태 제공 (bool)
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeStreamProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeStreamProviderRef<bool>;
String _$currentUserIdHash() => r'9e4459ccdc1c4c31cace126c081d703123013ee0';

/// 사용자 UID 제공
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = AutoDisposeProviderRef<String?>;
String _$matchingRepositoryHash() =>
    r'9efaca4f3c8686ecd7f52ef4bbe9fd34084ebb2e';

/// 매칭 Repository 제공
///
/// Copied from [matchingRepository].
@ProviderFor(matchingRepository)
final matchingRepositoryProvider =
    AutoDisposeProvider<MatchingRepository>.internal(
  matchingRepository,
  name: r'matchingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MatchingRepositoryRef = AutoDisposeProviderRef<MatchingRepository>;
String _$chatRepositoryHash() => r'3b05b2e86a376bda33d5f0aaa002537c2679aa84';

/// 채팅 Repository 제공
///
/// Copied from [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
