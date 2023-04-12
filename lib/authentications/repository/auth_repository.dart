import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/auth_services.dart';
import 'package:vooms/authentications/repository/user_services.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signUpUser(
      {required String fullname,
      required String email,
      required String password,
      required String phone});

  Future<Either<Failure, Unit>> signInUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOutUser();

  Stream<bool> listenToUserChanges();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final DBservice _authStore;

  AuthRepositoryImpl(this._authService, this._authStore);

  @override
  Future<Either<Failure, Unit>> signUpUser(
      {required String fullname,
      required String email,
      required String password,
      required String phone}) async {
    try {
      final model = await _authService.signUpUser(email, password);
      if (model != null) {
        await _authStore.save(UserEntity(fullname, phone,
                uid: model.uid,
                email: email,
                photoUrl: model.photoUrl,
                displayName: model.uid)
            .toMap());
      }
         debugPrint("==signUpUser==");
      return right(unit);
    } on SignUpWithEmailAndPasswordException catch (e) {
      debugPrint(e.toString());
      return left(AuthenticationError(e.message));
    } on AuthStoreException catch (e) {
      debugPrint(e.toString());
      return left(AuthenticationError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInUser(
      {required String email, required String password}) async {
    try {
      await _authService.signInUser(email, password);
      return right(unit);
    } on SignInWithEmailAndPasswordException catch (e) {
      return left(AuthenticationError(e.message));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> signOutUser() async {
    try {
      await _authService.signOut();
      return right(unit);
    } on SignOutException catch (_) {
      return left(AuthenticationError("Failure in logout..."));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(e.toString()));
    }
  }
  
  @override
  Stream<bool> listenToUserChanges() {
    return _authService.onAuthStateChanged.map((event){
      return event != null;
    });
  }
}
