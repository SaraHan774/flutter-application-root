import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/chat/send_message.dart';
import '../../domain/usecases/chat/get_messages.dart';
import '../../domain/usecases/chat/get_chat_room.dart';
import '../../domain/usecases/chat/close_chat_room.dart';
import '../../data/repositories/chat_repository_impl.dart';

part 'chat_provider.g.dart';

/// 채팅 상태 관리 Provider
/// 
/// 채팅 관련 상태와 비즈니스 로직을 관리합니다.
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<ChatRoomEntity?> build() async {
    // 초기 상태는 null (채팅방 없음)
    return null;
  }

  /// 채팅방을 로드합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  Future<void> loadChatRoom(String chatRoomId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = GetChatRoomUseCase(repository);
      final result = await useCase(chatRoomId);
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (chatRoom) => state = AsyncValue.data(chatRoom),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 활성 채팅방을 로드합니다.
  /// 
  /// [userId] 사용자 ID
  Future<void> loadActiveChatRoom(String userId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = GetChatRoomUseCase(repository); // TODO: getActiveChatRoom 구현 필요
      final result = await useCase(userId);
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (chatRoom) => state = AsyncValue.data(chatRoom),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 채팅방을 종료합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  Future<void> closeChatRoom(String chatRoomId) async {
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = CloseChatRoomUseCase(repository);
      final result = await useCase(chatRoomId);
      
      result.fold(
        (failure) => throw failure,
        (success) {
          if (success) {
            // 채팅방 종료 성공 시 상태를 null로 변경
            state = const AsyncValue.data(null);
          }
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 채팅방을 새로고침합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  Future<void> refreshChatRoom(String chatRoomId) async {
    await loadChatRoom(chatRoomId);
  }

  /// 채팅방 상태를 초기화합니다.
  void clearChatRoom() {
    state = const AsyncValue.data(null);
  }

  /// 메시지를 전송합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [message] 전송할 메시지
  /// [senderId] 발신자 ID
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
    required String senderId,
  }) async {
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = SendMessageUseCase(repository);
      final result = await useCase(
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: message,
      );
      
      result.fold(
        (failure) => throw failure,
        (success) {
          // 메시지 전송 성공 시 채팅방을 새로고침
          refreshChatRoom(chatRoomId);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// 메시지 목록 Provider
@riverpod
class MessagesNotifier extends _$MessagesNotifier {
  @override
  Future<List<MessageEntity>> build() async {
    return [];
  }

  /// 메시지 목록을 로드합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [limit] 조회할 메시지 수
  Future<void> loadMessages({
    required String chatRoomId,
    int limit = 50,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = GetMessagesUseCase(repository);
      final result = await useCase(chatRoomId);
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (messages) => state = AsyncValue.data(messages),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 메시지를 전송합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [senderId] 발신자 ID
  /// [text] 메시지 내용
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    try {
      final repository = ref.read(chatRepositoryProvider);
      final useCase = SendMessageUseCase(repository);
      final result = await useCase(
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
      );
      
      result.fold(
        (failure) => throw failure,
        (message) {
          // 새 메시지를 목록에 추가
          final currentMessages = state.value ?? [];
          state = AsyncValue.data([...currentMessages, message]);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 메시지 목록을 새로고침합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  Future<void> refreshMessages(String chatRoomId) async {
    await loadMessages(chatRoomId: chatRoomId);
  }

  /// 메시지 목록 Provider 인스턴스를 반환합니다.
  MessagesNotifier messagesProvider() {
    return this;
  }

  /// 메시지 목록을 초기화합니다.
  void clearMessages() {
    state = const AsyncValue.data([]);
  }

  /// 새 메시지를 추가합니다 (실시간 업데이트용).
  void addMessage(MessageEntity message) {
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([...currentMessages, message]);
  }

  /// 메시지 목록을 업데이트합니다 (실시간 업데이트용).
  void updateMessages(List<MessageEntity> messages) {
    state = AsyncValue.data(messages);
  }
}

/// 채팅 상태 Provider (간단한 상태만)
@riverpod
class ChatStatusNotifier extends _$ChatStatusNotifier {
  @override
  ChatStatus build() {
    return const ChatStatus();
  }

  /// 채팅 상태를 업데이트합니다.
  void updateStatus({
    bool? isLoading,
    bool? isConnected,
    String? errorMessage,
    String? currentChatRoomId,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      isConnected: isConnected,
      errorMessage: errorMessage,
      currentChatRoomId: currentChatRoomId,
    );
  }

  /// 로딩 상태를 설정합니다.
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// 연결 상태를 설정합니다.
  void setConnected(bool connected) {
    state = state.copyWith(isConnected: connected);
  }

  /// 에러 메시지를 설정합니다.
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// 현재 채팅방 ID를 설정합니다.
  void setCurrentChatRoomId(String? chatRoomId) {
    state = state.copyWith(currentChatRoomId: chatRoomId);
  }

  /// 상태를 초기화합니다.
  void reset() {
    state = const ChatStatus();
  }
}

/// 채팅 상태 데이터 클래스
class ChatStatus {
  const ChatStatus({
    this.isLoading = false,
    this.isConnected = false,
    this.errorMessage,
    this.currentChatRoomId,
  });

  final bool isLoading;
  final bool isConnected;
  final String? errorMessage;
  final String? currentChatRoomId;

  ChatStatus copyWith({
    bool? isLoading,
    bool? isConnected,
    String? errorMessage,
    String? currentChatRoomId,
  }) {
    return ChatStatus(
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage ?? this.errorMessage,
      currentChatRoomId: currentChatRoomId ?? this.currentChatRoomId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatStatus &&
        other.isLoading == isLoading &&
        other.isConnected == isConnected &&
        other.errorMessage == errorMessage &&
        other.currentChatRoomId == currentChatRoomId;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, isConnected, errorMessage, currentChatRoomId);
  }

  @override
  String toString() {
    return 'ChatStatus(isLoading: $isLoading, isConnected: $isConnected, '
           'errorMessage: $errorMessage, currentChatRoomId: $currentChatRoomId)';
  }
} 