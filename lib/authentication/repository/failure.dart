import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String errorMessage;
  const Failure({required this.errorMessage});
  @override
  List<Object> get props => [];
}


class AuthenticationError extends Failure {
 const AuthenticationError({required super.errorMessage});
}

class UserDataError extends Failure {
 const UserDataError({required super.errorMessage});
}

class TutorDataError extends Failure {
 const TutorDataError({required super.errorMessage});
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

class UserDataException implements Exception {}

class TutorDataException implements Exception {}
class CourseDataException implements Exception {}

class LoginWithFacebookException implements Exception {}

class LogInWithGoogleException implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleException([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleException.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleException(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleException(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleException(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleException(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleException(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleException(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleException();
    }
  }

  /// The associated error message.
  final String message;
}

class ResetPasswordException implements Exception {
  /// {@macro log_in_with_google_failure}
  const ResetPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory ResetPasswordException.fromCode(String code) {
    switch (code) {
      case 'auth/invalid-email':
        return const ResetPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'invalid-credential':
        return const ResetPasswordException(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const ResetPasswordException(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const ResetPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const ResetPasswordException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const ResetPasswordException(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const ResetPasswordException(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const ResetPasswordException(
          'The credential verification ID received is invalid.',
        );
      default:
        return const ResetPasswordException();
    }
  }

  /// The associated error message.
  final String message;
}