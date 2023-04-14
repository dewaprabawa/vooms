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

  factory UserEntity.fromMap(Map<String,dynamic> map) {
    return UserEntity(
       map["fullname"],
       map["phone"],
        uid: map["id"],
        email: map["email"],
        photoUrl: map["photoUrl"],
        displayName: map["displayName"],
    );
  }
}
