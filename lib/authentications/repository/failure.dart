import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}


class AuthenticationError extends Failure {
  final String errorMessage;

  AuthenticationError(this.errorMessage);
}

class SignUpWithEmailAndPasswordException implements Exception {

  const SignUpWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordException(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordException(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordException(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordException();
    }
  }

  /// The associated error message.
  final String message;
}


class SignInWithEmailAndPasswordException implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const SignInWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SignInWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordException(
          'Incorrect password, please try again.',
        );
      default:
        return const SignInWithEmailAndPasswordException();
    }
  }

  /// The associated error message.
  final String message;
}

class SignOutException implements Exception {}

class AuthStoreException implements Exception {}