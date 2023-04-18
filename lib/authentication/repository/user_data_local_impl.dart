import 'package:hive_flutter/hive_flutter.dart';


abstract class UserDBLocalService {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<List<Map<String,dynamic>>> retrieveList();
  Future<Map<String,dynamic>> retrieve(String id);
}


class UserDataLocalImpl implements UserDBLocalService {

  final Box _box;

  UserDataLocalImpl(this._box);

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Map<String,dynamic>>> retrieveList() async {
     return _box.values.map((e) => Map<String,dynamic>.from(e)).toList();
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