import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/chat_room_entity.dart';
import '../../repositories/chat_repository.dart';



/// 채팅방 정보를 조회하는 UseCase
/// 
/// 특정 채팅방의 상세 정보를 조회합니다.
class GetChatRoomUseCase {
  GetChatRoomUseCase(this._repository);

  final ChatRepository _repository;

  /// 채팅방 정보를 조회합니다.
  /// 
  /// [chatRoomId] 채팅방 ID
  /// 
  /// Returns:
  /// - 성공 시: 채팅방 정보
  /// - 실패 시: Failure 객체
  Future<Either<Failure, ChatRoomEntity>> call(String chatRoomId) async {
    try {
      final result = await _repository.getChatRoom(chatRoomId);
      if (result == null) {
        return Left(UnknownFailure('채팅방을 찾을 수 없습니다.'));
      }
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}


