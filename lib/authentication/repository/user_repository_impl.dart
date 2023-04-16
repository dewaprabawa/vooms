import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/db_service.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/authentication/repository/image_service_impl.dart';
import 'package:vooms/authentication/repository/user_entity.dart';
import 'package:vooms/authentication/repository/user_model.dart';
import 'package:vooms/authentication/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final DBservice _userDataRemote;
  final DBservice _userDataLocal;
  final ImageService _imageService;
  final AuthService _authService;

  UserRepositoryImpl(this._userDataRemote, this._userDataLocal,
      this._imageService, this._authService);

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final model = await _authService.currentUser;
      if (model != null) {
        final data = await _userDataRemote.retrieve(model.uid);
        final entity = UserEntity.fromMap(data);
        debugPrint(entity.toMap().toString());
        return Right(entity);
      }
      return const Left(
          UserDataError(errorMessage: 'Failed to retrieve user data'));
    } on UserStoreException {
      return const Left(
          UserDataError(errorMessage: 'Failed to retrieve user data'));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadImageUser(File file) async {
    try {
      final model = await _authService.currentUser;
      if (model != null) {
        final photoUrl = await _imageService.uploadImage(file);
        final userMap = await _userDataRemote.retrieve(model.uid);
        print("==RETRIEVE photoUrl ${photoUrl.toString()}");
        userMap["photoUrl"] = photoUrl;
         print("==INSERT ${userMap.toString()}");
        Future.wait([
            _userDataRemote.save(userMap),
            // _userDataLocal.save(userMap), 
        ]);
        return const Right(unit);
      }
       return const Left(
          UserDataError(errorMessage: 'Failed to update photo url data'));
    } on UserStoreException {
      return const Left(
          UserDataError(errorMessage: 'Failed to update photo url data'));
    }
  }
}
