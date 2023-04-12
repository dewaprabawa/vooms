import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/auth_services.dart';
import 'package:vooms/authentications/repository/user_services.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_entity.dart';

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
  final DBservice _authStore;

  AuthRepositoryImpl(this._authService, this._authStore);

  // Implementation of the signUpUser function for registering a new user with the given details.
  @override
  Future<Either<Failure, Unit>> signUpUser(
      {required String fullname,
      required String email,
      required String password,
      required String phone}) async {
    try {
      final model = await _authService.signUpUser(email, password); // Call the signUpUser function of AuthService to register the user.
      if (model != null) {
        // Save the user details to the database if the user registration was successful.
        await _authStore.save(UserEntity(fullname, phone,
                uid: model.uid,
                email: model.email,
                photoUrl: model.photoUrl,
                displayName: model.uid)
            .toMap());
      }
      debugPrint("==signUpUser==");
      return right(unit); // Return a success message.
    } on SignUpWithEmailAndPasswordException catch (e) {
      debugPrint(e.toString()); // Print the error message to the console.
      return left(AuthenticationError(e.message)); // Return an error message using the custom Failure class.
    } on AuthStoreException catch (e) {
      debugPrint(e.toString()); // Print the error message to the console.
      return left(AuthenticationError(e.toString())); // Return an error message using the custom Failure class.
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
      return left(AuthenticationError(e.message));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOutUser() async {
    try {
      await _authService.signOut();
            debugPrint("==signOutUser==");
      return right(unit);
    } on SignOutException catch (_) {
      return left(AuthenticationError("Failure in logout..."));
    } on AuthStoreException catch (e) {
      return left(AuthenticationError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> googleSignIn() async {
    try {
      final model = await _authService.signInWithGoogle();
      if (model != null) {
        await _authStore.save(UserEntity(model.displayName, "",
                uid: model.uid,
                email: model.email,
                photoUrl: model.photoUrl,
                displayName: model.uid)
            .toMap());
      }
      debugPrint("==googleSignIn==");
       return right(unit);
    } on LogInWithGoogleException catch (e) {
       return left(AuthenticationError(e.message));
    } on AuthStoreException catch (e){
      return left(AuthenticationError(e.toString()));
    }
  }

  @override
  Stream<bool> listenToUserChanges() {
    return _authService.onAuthStateChanged.map((event) {
      return event != null;
    });
  }
}
