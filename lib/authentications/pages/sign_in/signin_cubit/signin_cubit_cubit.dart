import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/authentications/pages/sign_in/signin_cubit/validation_models/email.dart';
import 'package:vooms/authentications/pages/sign_in/signin_cubit/validation_models/password.dart';

part 'signin_cubit_state.dart';

class SigninCubitCubit extends Cubit<SigninState> {
  SigninCubitCubit() : super(const SigninState());
}
