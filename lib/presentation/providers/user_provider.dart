import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/user/get_user_profile.dart';
import '../../domain/usecases/user/update_user_profile.dart';
import '../../domain/domain.dart';
import 'auth_provider.dart'; // userRepositoryProvider를 사용하기 위해 import

part 'user_provider.g.dart';

/// 사용자 상태 관리 Provider
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<UserEntity?> build() {
    // 초기 상태는 null (사용자 정보 없음)
    return null;
  }

  /// 사용자 프로필 조회
  Future<void> getUserProfile(String userId) async {
    try {
      state = const AsyncValue.loading();
      
      final getUserProfileUseCase = GetUserProfileUseCase(
        ref.read(userRepositoryProvider),
      );
      
      final user = await getUserProfileUseCase.call(userId);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 사용자 프로필 업데이트
  Future<void> updateUserProfile({
    required String userId,
    String? nickname,
    List<String>? emotionTags,
    String? preferredTime,
    double? empathyScore,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final updateUserProfileUseCase = UpdateUserProfileUseCase(
        ref.read(userRepositoryProvider),
      );
      
      final updatedUser = await updateUserProfileUseCase.call(
        userId: userId,
        nickname: nickname,
        emotionTags: emotionTags,
        preferredTime: preferredTime,
        empathyScore: empathyScore,
      );
      
      state = AsyncValue.data(updatedUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 사용자 프로필 생성 (새 사용자용)
  Future<void> createUserProfile({
    required String userId,
    required String nickname,
    required List<String> emotionTags,
    required String preferredTime,
    double? empathyScore,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final updateUserProfileUseCase = UpdateUserProfileUseCase(
        ref.read(userRepositoryProvider),
      );
      
      final newUser = await updateUserProfileUseCase.call(
        userId: userId,
        nickname: nickname,
        emotionTags: emotionTags,
        preferredTime: preferredTime,
        empathyScore: empathyScore,
      );
      
      state = AsyncValue.data(newUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 사용자 상태 초기화
  void clearUser() {
    state = const AsyncValue.data(null);
  }

  /// 현재 사용자 정보 새로고침
  Future<void> refreshUserProfile(String userId) async {
    await getUserProfile(userId);
  }
} 