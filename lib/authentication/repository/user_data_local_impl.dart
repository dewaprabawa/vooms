import 'package:hive_flutter/hive_flutter.dart';
import 'package:vooms/authentication/repository/db_service.dart';

class UserDataLocalImpl implements DBservice {

  final Box _box;

  UserDataLocalImpl(this._box);

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Map<String,dynamic>>> retrieveList(String key) async {
     return [_box.values.first];
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
      await _box.put(map["id"], map);
  }

  @override
  Future<void> update(Map<String, dynamic> map) async {
      await _box.put(map["id"], map);
  }
  
  @override
  Future<Map<String, dynamic>> retrieve(String id) {
    // TODO: implement retrieve
    throw UnimplementedError();
  }

}