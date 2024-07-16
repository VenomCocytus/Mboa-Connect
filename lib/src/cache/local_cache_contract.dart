abstract class ILocalCache {
  Future<void> save(String key, Map<String, dynamic> cacheJson);
  Map<String, dynamic> fetch(String key);
}