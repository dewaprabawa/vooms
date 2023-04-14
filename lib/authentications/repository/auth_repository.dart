import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/auth_service.dart';
import 'package:vooms/authentications/repository/auth_service_impl.dart';
import 'package:vooms/authentications/repository/db_service.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_entity.dart';
import 'package:vooms/authentications/repository/user_model.dart';

// An abstract class that defines authentication-related operations.
abstract class AuthRepository {
  // A function for signing up a new user with the given details.
  Future<Either<Failure, Unit>> signUpUser(
      {required String fullname,
      required String email,
      required String password,
      required String phone});

  // A function for signing in an existing user with the given credentials.
  Future<Either<Failure, Unit>> signInUser({
    required String email,
    required String password,
  });

  // A function for signing in a user with their Google account.
  Future<Either<Failure, Unit>> googleSignIn();

  // A function for signing out the current user.
  Future<Either<Failure, Unit>> signOutUser();

  // A stream that listens for changes in the current user's authentication state.
  Stream<bool> listenToUserChanges();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final DBservice _authStoreRemote;
  final DBservice _authStoreLocal;

  AuthRepositoryImpl(
      this._authService, this._authStoreRemote, this._authStoreLocal);

  // Implementation of the signUpUser function for registering a new user with the given details.
  @override
  Future<Either<Failure, Unit>> signUpUser(
      {required String fullname,
      required String email,
      required String password,
      required String phone}) async {
    try {
      final model = await _authService.signUpUser(email,
          password); // Call the signUpUser function of AuthService to register the user.
      _saveCredentialUser(model, fullname, phone);
      debugPrint("==signUpUser==");
      return right(unit); // Return a success message.
    } on SignUpWithEmailAndPasswordException catch (e) {
      debugPrint(e.toString()); // Print the error message to the console.
      return left(AuthenticationError(
          errorMessage: e
              .message)); // Return an error message using the custom Failure class.
    } on AuthStoreException catch (e) {
      debugPrint(e.toString()); // Print the error message to the console.
      return left(AuthenticationError(
          errorMessage: e
              .toString())); // Return an error message using the custom Failure class.
    }
  }

  @override
  Future<Either<Failure, Unit>> signInUser(
      {required String email, required String password}) async {
    try {
      await _authService.signInUser(email, password);
      debugPrint("==signInUser==");
      return right(unit);
    } on SignInWithEmailAndPasswordException catch (e) {
      return left(AuthenticationError(errorMessage: e.message));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOutUser() async {
    try {
      await _authService.signOut();
      debugPrint("==signOutUser==");
      return right(unit);
    } on SignOutException catch (e) {
      return left(AuthenticationError(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> googleSignIn() async {
    try {
      final model = await _authService.signInWithGoogle();
      _saveCredentialUser(model, null, null);
      debugPrint("==googleSignIn==");
      return right(unit);
    } on LogInWithGoogleException catch (e) {
      return left(AuthenticationError(errorMessage: e.message));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(errorMessage: e.toString()));
    }
  }

  @override
  Stream<bool> listenToUserChanges() {
    return _authService.onAuthStateChanged.map((event) {
      return event != null;
    });
  }

  void _saveCredentialUser(UserModel? model, String? fullname, String? phone) {
    if (model != null) {
      // Save the user details to the database if the user registration was successful.
      Future.wait([
        _authStoreRemote.save(UserEntity(
                fullname ?? model.displayName, phone ?? "",
                uid: model.uid,
                email: model.email,
                photoUrl: model.photoUrl,
                displayName: model.uid)
            .toMap()),
        _authStoreLocal.save(UserEntity(
                fullname ?? model.displayName, phone ?? "",
                uid: model.uid,
                email: model.email,
                photoUrl: model.photoUrl,
                displayName: model.uid)
            .toMap()),
      ]);
    }
  }
}
