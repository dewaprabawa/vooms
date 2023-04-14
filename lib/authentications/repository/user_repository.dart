import 'package:vooms/authentications/repository/user_model.dart';


abstract class UserRepository {
  Future<UserModel> getUser();
  Future<UserModel> uploadImageUser();
}