
part of 'sign_up_cubit.dart';


class SignUpState extends Equatable {
  
  const SignUpState({
    this.email = const Email.pure(),
    this.fullName = const FullName.pure(),
    this.password = const Password.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isSecurity = false,
  });


  final Email email;
  final FullName fullName;
  final Password password;
  final PhoneNumber phoneNumber;
  final ConfirmPassword confirmPassword;
  final FormzStatus status;
  final String? errorMessage;
  final bool isSecurity;

  @override
  List<Object?> get props => [
        email,
        fullName,
        password,
        confirmPassword,
        status,
        errorMessage,
        phoneNumber,
        isSecurity,
      ];

  SignUpState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzStatus? status,
    PhoneNumber? phoneNumber,
    String? errorMessage,
    bool? isSecurity,
  }) {
    return SignUpState(
      isSecurity: isSecurity ?? this.isSecurity,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}