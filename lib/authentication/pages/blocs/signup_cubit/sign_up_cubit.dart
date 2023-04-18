import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/validation_models/email.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/validation_models/confirm_password.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/validation_models/full_name.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/validation_models/password.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/validation_models/phone_numbar.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';
import 'package:vooms/authentication/repository/failure.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  bool get isStillPure => (state.email.pure &&
      state.password.pure &&
      state.fullName.pure &&
      state.phoneNumber.pure);

  bool get isAnyOfFieldInValid =>
      state.fullName.invalid ||
      state.email.invalid ||
      state.password.invalid ||
      state.phoneNumber.invalid;

  void onSecureOnChanged() {
    emit(state.copyWith(isSecurity: !state.isSecurity));
  }

  void fullNameChanged(String value) {
    final fullName = FullName.dirty(value);
    emit(state.copyWith(
      fullName: fullName,
      status: Formz.validate([
        fullName,
        state.email,
        state.password,
        state.confirmPassword,
        state.phoneNumber
      ]),
    ));
  }

  void phoneNumberChanged(String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: Formz.validate([
        phoneNumber,
        state.fullName,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.fullName,
        email,
        state.password,
        state.confirmPassword,
        state.phoneNumber
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmPassword = ConfirmPassword.dirty(
        password: value, value: state.confirmPassword.password);
    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.fullName,
        state.email,
        password,
        confirmPassword,
        state.phoneNumber
      ]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final password = Password.dirty(state.password.value);
    final confirmPassword =
        ConfirmPassword.dirty(password: password.value, value: value);
    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.fullName,
        state.email,
        password,
        confirmPassword,
        state.phoneNumber
      ]),
    ));
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final data = await _authRepository.googleSignIn();
    data.fold((error) {
      emit(state.copyWith(
          errorMessage: error.errorMessage,
          status: FormzStatus.submissionFailure));
    }, (_) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    });
  }

  Future<void> signUp() async {
    if (state.status.isInvalid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final either = await _authRepository.signUpUser(
        fullname: state.fullName.value,
        phone: state.phoneNumber.value,
        email: state.email.value,
        password: state.password.value);

    if (either.isLeft()) {
      either.leftMap((error) => emit(state.copyWith(
          errorMessage: error.errorMessage,
          status: FormzStatus.submissionFailure)));
      return;
    }

    if (either.isRight()) {
      emit(state.copyWith(
        fullName: const FullName.pure(),
        email: const Email.pure(),
        password: const Password.pure(),
        confirmPassword: const ConfirmPassword.pure(),
        phoneNumber: const PhoneNumber.pure(),
        status: FormzStatus.submissionSuccess,
      ));
    }
  }
}
