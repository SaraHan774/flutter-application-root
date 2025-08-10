import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../repositories/chat_repository.dart';



/// 채팅방을 종료하는 UseCase
/// 
/// 채팅방을 수동으로 종료하고 관련 리소스를 정리합니다.
class CloseChatRoomUseCase {
  CloseChatRoomUseCase(this._repository);

  final ChatRepository _repository;

  /// 채팅방을 종료합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns:
  /// - 성공 시: true
  /// - 실패 시: Failure 객체
  Future<Either<Failure, bool>> call(String chatRoomId) async {
    try {
      await _repository.closeChatRoom(chatRoomId);
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}


