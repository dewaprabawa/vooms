import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vooms/authentications/pages/blocs/signin_cubit/validation_models/email.dart';
import 'package:vooms/authentications/pages/blocs/signin_cubit/validation_models/password.dart';
import 'package:vooms/authentications/repository/auth_repository.dart';


part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(const SignInState());

  final AuthRepository _authRepository;
 
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

    Future<void> signInUser(String email, String password) async {
     emit(state.copyWith(currentStatus: FormzStatus.submissionInProgress));
      final data = await _authRepository.signInUser(email: email, password: password);
      data.fold((error) {
        emit(state.copyWith(
            errorMessage: error.errorMessage, currentStatus: FormzStatus.submissionFailure));
      }, (_) {
         emit(state.copyWith(currentStatus: FormzStatus.submissionSuccess));
      });
  }

}
