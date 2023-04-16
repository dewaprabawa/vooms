import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/authentication/repository/user_entity.dart';


abstract class UserRepository {
  Future<Either<Failure,UserEntity>> getUser();
  Future<Either<Failure,Unit>> uploadImageUser(File file);
  
}