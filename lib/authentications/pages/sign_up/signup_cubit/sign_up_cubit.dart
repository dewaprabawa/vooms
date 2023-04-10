import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vooms/authentications/pages/sign_up/signup_cubit/validation_models/confirm_password.dart';
import 'package:vooms/authentications/pages/sign_up/signup_cubit/validation_models/email.dart';
import 'package:vooms/authentications/pages/sign_up/signup_cubit/validation_models/full_name.dart';
import 'package:vooms/authentications/pages/sign_up/signup_cubit/validation_models/password.dart';
import 'package:vooms/authentications/pages/sign_up/signup_cubit/validation_models/phone_numbar.dart';



part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

   void onSecureOnChanged(){
    emit(state.copyWith(
      isSecurity: !state.isSecurity
    ));
   }

   void fullNameChanged(String value) {
    final fullName = FullName.dirty(value);
    emit(state.copyWith(
      fullName: fullName,
      status:  Formz.validate([fullName, state.email, state.password, state.confirmPassword, state.phoneNumber]),
    ));
  }

  void phoneNumberChanged(String value){
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status:  Formz.validate([phoneNumber, state.fullName, state.email, state.password, state.confirmPassword]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status:  Formz.validate([state.fullName, email, state.password, state.confirmPassword, state.phoneNumber]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmPassword = ConfirmPassword.dirty(password: value, value: state.confirmPassword.password);
    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status:  Formz.validate([state.fullName, state.email, password, confirmPassword, state.phoneNumber]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(password:password.value, value: value);
    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status: Formz.validate([state.fullName, state.email, password, confirmPassword, state.phoneNumber]),
    ));
  }

  Future<void> signUp() async {
    if (state.status.isInvalid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      // Call your sign up API here
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
