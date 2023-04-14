
import 'package:dartz/dartz.dart';
import 'package:vooms/authentications/repository/db_service.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_entity.dart';
import 'package:vooms/authentications/repository/user_model.dart';
import 'package:vooms/authentications/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

  final DBservice _userDataRemote;
  final DBservice _userDataLocal;

  UserRepositoryImpl(
    this._userDataRemote, 
    this._userDataLocal);

 @override
Future<Either<Failure, UserEntity>> getUser() async {
  try {
    final data = await _userDataRemote.retrieve();
    final user = UserEntity.fromMap(data);
    return Right(user);
  } on UserStoreException {
    return const Left(UserDataError(errorMessage: 'Failed to retrieve user data'));
  }
}


  @override
  Future<Either<Failure, UserEntity>> uploadImageUser() {
    // TODO: implement uploadImageUser
    throw UnimplementedError();
  }


}