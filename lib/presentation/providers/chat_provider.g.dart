// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatNotifierHash() => r'6e4533e771e267d29841fe9e892d71a0cb536d67';

/// 채팅 상태 관리 Provider
///
/// 채팅 관련 상태와 비즈니스 로직을 관리합니다.
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, ChatRoomEntity?>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<ChatRoomEntity?>;
String _$messagesNotifierHash() => r'b2ca59f9a49a11133f2e6bad6b85051d24bdf2fc';

/// 메시지 목록 Provider
///
/// Copied from [MessagesNotifier].
@ProviderFor(MessagesNotifier)
final messagesNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MessagesNotifier, List<MessageEntity>>.internal(
  MessagesNotifier.new,
  name: r'messagesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messagesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MessagesNotifier = AutoDisposeAsyncNotifier<List<MessageEntity>>;
String _$chatStatusNotifierHash() =>
    r'27a0f4b5c47f5f40f19eb3c5d352ba49daba5803';

/// 채팅 상태 Provider (간단한 상태만)
///
/// Copied from [ChatStatusNotifier].
@ProviderFor(ChatStatusNotifier)
final chatStatusNotifierProvider =
    AutoDisposeNotifierProvider<ChatStatusNotifier, ChatStatus>.internal(
  ChatStatusNotifier.new,
  name: r'chatStatusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatStatusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatStatusNotifier = AutoDisposeNotifier<ChatStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
