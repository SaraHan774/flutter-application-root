import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/chat/send_message.dart';
import '../../core/di/service_locator.dart';

/// 채팅 상태
class ChatState {
  final ChatRoomEntity? activeChatRoom;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? messagesStream;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.activeChatRoom,
    this.messagesStream,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    ChatRoomEntity? activeChatRoom,
    Stream<QuerySnapshot<Map<String, dynamic>>>? messagesStream,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      activeChatRoom: activeChatRoom ?? this.activeChatRoom,
      messagesStream: messagesStream ?? this.messagesStream,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 채팅 상태 관리 Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final ChatRepository _chatRepository;
  final String? _currentUserId;

  ChatNotifier(this._sendMessageUseCase, this._chatRepository, this._currentUserId) 
      : super(const ChatState());

  /// 활성 채팅방 설정
  void setActiveChatRoom(ChatRoomEntity chatRoom) {
    final messagesStream = _chatRepository.getMessagesStream(chatRoom.chatRoomId);
    state = state.copyWith(
      activeChatRoom: chatRoom,
      messagesStream: messagesStream,
    );
  }

  /// 채팅방 종료
  void closeActiveChatRoom() {
    state = state.copyWith(
      activeChatRoom: null,
      messagesStream: null,
    );
  }

  /// 메시지 전송
  Future<void> sendMessage({
    required String content,
    String? messageType,
  }) async {
    if (state.activeChatRoom == null) {
      state = state.copyWith(error: '활성 채팅방이 없습니다.');
      return;
    }

    if (_currentUserId == null) {
      state = state.copyWith(error: '사용자 인증이 필요합니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _sendMessageUseCase(
        chatRoomId: state.activeChatRoom!.chatRoomId,
        senderId: _currentUserId!,
        content: content,
        messageType: messageType,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 로딩 상태 초기화
  void clearLoading() {
    state = state.copyWith(isLoading: false);
  }
}

/// 채팅 Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatRepository = ref.watch(getChatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return ChatNotifier(
    SendMessageUseCase(chatRepository),
    chatRepository,
    currentUserId,
  );
}); 