import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vooms/authentications/pages/sign_in/signin_cubit/validation_models/email.dart';
import 'package:vooms/authentications/pages/sign_in/signin_cubit/validation_models/password.dart';

part 'sign_in_state.dart';

class SigninCubit extends Cubit<SignInState> {
  SigninCubit() : super(const SignInState());

  //   Future<void> signIn() async {
  //   if (state.status.isInvalid) return;
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     final data = await authRepository.signUpUser(
  //         fullname: state.fullName.value,
  //         phone: state.phoneNumber.value,
  //         email: state.email.value,
  //         password: state.password.value);
  //     data.fold((error) {
  //       String errorMessage = (error as AuthenticationError).errorMessage;
  //       emit(state.copyWith(
  //           errorMessage: errorMessage, status: FormzStatus.submissionFailure));
  //     }, (_) {
  //       emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //     });
  //   } catch (e) {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
}
