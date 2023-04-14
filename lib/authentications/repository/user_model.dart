import 'package:firebase_auth/firebase_auth.dart';
import 'package:vooms/authentications/repository/user_entity.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

class Mapper {
  static UserModel toModel(User user) {
    return UserModel(
        uid: user.uid,
        email: user.email ?? "",
        photoUrl: user.photoURL ?? "",
        displayName: user.displayName ?? "");
  }

  static UserEntity toEntity(Map<dynamic, String> map) {
    return UserEntity(
        map["fullname"] ?? "", 
        map["phone"] ?? "",
        uid: map["id"] ?? "",
        email: map["email"] ?? "",
        photoUrl: map["photoUrl"] ?? "",
        displayName: map["displayName"] ?? "");
  }
}
