import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/validation_models/email.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/validation_models/password.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(const SignInState());

  final AuthRepository _authRepository;

  bool get isStillPure =>
      (state.email.pure && state.password.pure) ||
      !state.email.valid ||
      !state.password.valid;

  void isRememberMe(bool isRemember) {
    emit(state.copyWith(isRememberMe: isRemember));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      currentStatus: Formz.validate([
        email,
        state.password,
      ]),
    ));
  }

  void onSecureOnChanged() {
    emit(state.copyWith(isSecurity: !state.isSecurity));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      currentStatus: Formz.validate([
        state.email,
        password,
      ]),
    ));
  }

  Future<void> signInUser() async {
    if (state.status.isInvalid) return;
    emit(state.copyWith(currentStatus: FormzStatus.submissionInProgress));
    final data = await _authRepository.signInUser(
        email: state.email.value, password: state.password.value);
    data.fold((error) {
      emit(state.copyWith(
          errorMessage: error.errorMessage,
          currentStatus: FormzStatus.submissionFailure));
    }, (_) {
      // If the "Remember Me" option is selected, save the user's credentials to local storage
      _authRepository.saveUserCredentials(
          state.email.value, state.password.value, state.isRememberMe);

      emit(state.copyWith(
          currentStatus: FormzStatus.submissionSuccess,
          email: const Email.pure(),
          password: const Password.pure()));
    });
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(currentStatus: FormzStatus.submissionInProgress));
    final either = await _authRepository.startResetPassword(email);
    either.fold(
        (e) =>
            emit(state.copyWith(
              errorMessage: e.errorMessage,
              currentStatus: FormzStatus.submissionFailure)),
        (_) =>
            emit(state.copyWith(currentStatus: FormzStatus.submissionSuccess)));
  }
}
