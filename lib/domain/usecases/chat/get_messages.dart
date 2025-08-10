import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';



/// 채팅방의 메시지 목록을 조회하는 UseCase
/// 
/// 특정 채팅방의 모든 메시지를 시간순으로 조회합니다.
class GetMessagesUseCase {
  GetMessagesUseCase(this._repository);

  final ChatRepository _repository;

  /// 메시지 목록을 조회합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// [limit] 조회할 메시지 수 (기본값: 50)
  /// 
  /// Returns:
  /// - 성공 시: 메시지 목록
  /// - 실패 시: Failure 객체
  Future<Either<Failure, List<MessageEntity>>> call(String chatRoomId) async {
    try {
      final result = await _repository.getMessages(chatRoomId);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}


