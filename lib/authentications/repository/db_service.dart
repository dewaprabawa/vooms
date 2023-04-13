
abstract class DBservice<T> {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<T> retrieve(String key);
}
