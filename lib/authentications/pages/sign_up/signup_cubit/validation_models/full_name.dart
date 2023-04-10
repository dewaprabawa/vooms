import 'package:formz/formz.dart';

class FullName extends FormzInput<String, String> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([String value = '']) : super.dirty(value);

  static final _nameRegExp = RegExp(
    r'^[a-zA-Z ]+$',
  );

  String? getReturnValidationValue(String text){
    
    if(text.length <= 4){
      return "The full name should be more than 4 characters";
    }

    /*if(_nameRegExp.hasMatch(text)){
      return 'Invalid name format';
    }*/
    
    return null;
  }

  @override
  String? validator(String value) {
    return getReturnValidationValue(value);
  }
}


