import 'package:vooms/authentication/repository/user_model.dart';

class UserEntity extends UserModel {
  UserEntity(this.fullname, this.phone, this.address,
      {required super.uid,
      required super.email,
      required super.photoUrl,
      required super.displayName,});

  final String fullname;
  final String phone;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      "id": uid,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      "photoUrl": photoUrl,
      "displayName": displayName,
      "address": address,
    };
  }

  factory UserEntity.fromMap(Map<String,dynamic> map) {
    return UserEntity(
       map["fullname"],
       map["phone"],
       map["address"],
        uid: map["id"],
        email: map["email"],
        photoUrl: map["photoUrl"],
        displayName: map["displayName"],
    );
  }
}
