import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';

/// 채팅 메시지 전송 UseCase
class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  /// 채팅방에 메시지 전송
  Future<Either<Failure, MessageEntity>> call({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    try {
      final result = await repository.sendMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
} 