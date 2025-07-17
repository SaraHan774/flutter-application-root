import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_user_datasource.dart';
import '../models/user_model.dart';

/// User Repository 구현체
class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<UserEntity?> getUserById(String uid) async {
    final userModel = await _userDataSource.getUserById(uid);
    return userModel?.toEntity();
  }

  @override
  Future<bool> isNicknameDuplicate(String nickname) async {
    return await _userDataSource.isNicknameDuplicate(nickname);
  }

  @override
  Future<void> createUserProfile(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _userDataSource.createUserProfile(userModel);
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _userDataSource.updateUserProfile(userModel);
  }
} 