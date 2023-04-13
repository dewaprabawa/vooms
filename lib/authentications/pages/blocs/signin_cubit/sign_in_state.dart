part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isSecurity = false,
    this.status = FormzStatus.pure,
    this.errorMessage = "",
  });
  
  final Email email;
  final Password password;
  final bool isSecurity;
  final FormzStatus status;
  final String errorMessage;

  SignInState copyWith({
    Email? email,
    Password? password,
    bool? isSecurity,
    FormzStatus? currentStatus,
    String? errorMessage,
  }) {
    return SignInState(
      errorMessage: errorMessage ?? this.errorMessage,
      isSecurity: isSecurity ?? this.isSecurity,
      email: email ?? this.email,
      password: password ?? this.password,
      status: currentStatus ?? this.status,
    );
  }

  @override
  List<Object> get props => [email,password, status, isSecurity];
}

