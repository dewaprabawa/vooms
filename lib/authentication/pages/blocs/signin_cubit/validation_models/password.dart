import 'package:formz/formz.dart';

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  String? validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : 'Password must contain at least 8 characters, including one letter and one number';
  }
}
