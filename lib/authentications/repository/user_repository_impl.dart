
import 'package:vooms/authentications/repository/db_service.dart';
import 'package:vooms/authentications/repository/user_data_local_impl.dart';
import 'package:vooms/authentications/repository/user_model.dart';
import 'package:vooms/authentications/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

  final DBservice _userDataRemote;
  final DBservice _userDataLocal;

  UserRepositoryImpl(
    this._userDataRemote, 
    this._userDataLocal);

  @override
  Future<UserModel> getUser() async {
     List<Map<dynamic,String>> data = await _userDataLocal.retrieve("");
     return Mapper.toEntity(data.first);
  }

  @override
  Future<UserModel> uploadImageUser() {
    // TODO: implement uploadImageUser
    throw UnimplementedError();
  }
}