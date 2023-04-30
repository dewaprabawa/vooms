abstract class BaseMethod {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<List<Map<String,dynamic>>> retrieveList();
  Future<Map<String,dynamic>> retrieve(String id);
}