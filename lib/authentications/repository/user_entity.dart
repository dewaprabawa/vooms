import 'package:vooms/authentications/repository/user_model.dart';

class UserEntity extends UserModel {
  UserEntity(this.fullname, this.phone,
      {required super.uid,
      required super.email,
      required super.photoUrl,
      required super.displayName});

  final String fullname;
  final String phone;

  Map<String, dynamic> toMap() {
    return {
      "id": uid,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      "photoUrl": photoUrl,
      "displayName": displayName
    };
  }
}
