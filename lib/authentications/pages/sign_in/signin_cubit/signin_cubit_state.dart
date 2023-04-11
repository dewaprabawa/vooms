part of 'signin_cubit_cubit.dart';

class SigninState extends Equatable {
  const SigninState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isSecurity = false,
  });
  
  final Email email;
  final Password password;
  final bool isSecurity;

  SigninState copyWith({
    Email? email,
    Password? password,
    bool? isSecurity,
  }) {
    return SigninState(
      isSecurity: isSecurity ?? this.isSecurity,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [email,password];
}


