import '../../repositories/chat_repository.dart';

/// 채팅 메시지 전송 UseCase
class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  /// 채팅방에 메시지 전송
  Future<void> call({
    required String chatRoomId,
    required String senderId,
    required String content,
    String? messageType,
  }) async {
    await repository.sendMessage(
      chatRoomId: chatRoomId,
      senderId: senderId,
      content: content,
      messageType: messageType,
    );
  }
} 