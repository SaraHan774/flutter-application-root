import '../../repositories/chat_repository.dart';
import '../../entities/message_entity.dart';

/// 채팅 메시지 전송 UseCase
class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  /// 채팅방에 메시지 전송
  Future<void> call(String chatRoomId, MessageEntity message) async {
    await repository.sendMessage(chatRoomId, message);
  }
} 