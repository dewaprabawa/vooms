import 'package:formz/formz.dart';

class PhoneNumber extends FormzInput<String, String> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final _nameRegExp = RegExp(
    r'^(?:[+0]9)?[0-9]{10}$'
  );

  String? getReturnValidationValue(String text){
    

    if(!_nameRegExp.hasMatch(text) && text.length < 12){
      return 'Invalid phone number format';
    }
    
    return null;
  }

  @override
  String? validator(String value) {
    return getReturnValidationValue(value);
  }
}

