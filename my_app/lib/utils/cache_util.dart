// ignore_for_file: avoid_print

class CacheUtil 
{
  static final Map<String, dynamic> _cache = {};

   static void cacheData(String key, dynamic data) {
    print("Caching data for key: $key"); // Logging
    _cache[key] = data;
  }

  static dynamic getData(String key) {
    if (_cache.containsKey(key)) {
      print("Retrieving data from cache for key: $key"); // Logging cache hit
      return _cache[key];
    } else {
      print("Cache miss for key: $key"); // Logging cache miss
      return null;
    }
  }

  static bool hasData(String key) {
    return _cache.containsKey(key);
  }
}