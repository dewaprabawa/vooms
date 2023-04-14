
abstract class DBservice {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<List<Map<String,dynamic>>> retrieveList(String key);
  Future<Map<String,dynamic>> retrieve();
}


