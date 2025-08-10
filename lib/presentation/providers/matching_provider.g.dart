// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$matchingNotifierHash() => r'02f5697c9a47a8956e4ef5f973ffa98562fba859';

/// 매칭 상태 관리 Provider
///
/// 매칭 관련 상태와 비즈니스 로직을 관리합니다.
///
/// Copied from [MatchingNotifier].
@ProviderFor(MatchingNotifier)
final matchingNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MatchingNotifier, MatchingEntity?>.internal(
  MatchingNotifier.new,
  name: r'matchingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MatchingNotifier = AutoDisposeAsyncNotifier<MatchingEntity?>;
String _$matchingHistoryNotifierHash() =>
    r'67963a8ef21dd88431ad7d99fb8ecb28cb066002';

/// 매칭 이력 Provider
///
/// Copied from [MatchingHistoryNotifier].
@ProviderFor(MatchingHistoryNotifier)
final matchingHistoryNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MatchingHistoryNotifier, List<MatchingEntity>>.internal(
  MatchingHistoryNotifier.new,
  name: r'matchingHistoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchingHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MatchingHistoryNotifier
    = AutoDisposeAsyncNotifier<List<MatchingEntity>>;
String _$matchingStatusNotifierHash() =>
    r'53378a970aac42d129d5a13f57e907faca47ea76';

/// 매칭 상태 Provider (간단한 상태만)
///
/// Copied from [MatchingStatusNotifier].
@ProviderFor(MatchingStatusNotifier)
final matchingStatusNotifierProvider = AutoDisposeNotifierProvider<
    MatchingStatusNotifier, MatchingStatus>.internal(
  MatchingStatusNotifier.new,
  name: r'matchingStatusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchingStatusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MatchingStatusNotifier = AutoDisposeNotifier<MatchingStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
