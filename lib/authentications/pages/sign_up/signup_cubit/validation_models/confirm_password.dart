import 'package:formz/formz.dart';

class ConfirmPassword extends FormzInput<String, String> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  String? validator(String value) {
    return password == value ? null : 'Passwords do not match';
  }
}


