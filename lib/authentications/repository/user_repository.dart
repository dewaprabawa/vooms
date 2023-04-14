import 'package:dartz/dartz.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_entity.dart';


abstract class UserRepository {
  Future<Either<Failure,UserEntity>> getUser();
  Future<Either<Failure,UserEntity>> uploadImageUser();
}