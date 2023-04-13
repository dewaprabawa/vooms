import 'package:hive_flutter/hive_flutter.dart';
import 'package:vooms/authentications/repository/db_service.dart';

class UserServiceLocalImpl implements DBservice<List<Map<String,dynamic>>> {

  final Box _box;

  UserServiceLocalImpl(this._box);

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Map<String,dynamic>>> retrieve(String key) {
    throw UnimplementedError();
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
      await _box.put(map["id"], map);
  }

  @override
  Future<void> update(Map<String, dynamic> map) async {
      await _box.put(map["id"], map);
  }

}