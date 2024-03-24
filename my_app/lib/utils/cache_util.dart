// ignore_for_file: avoid_print

class CacheUtil {
  static final Map<String, dynamic> _cache = {};

  static void cacheData(String key, dynamic data) {
    _cache[key] = data;
  }

  static dynamic getData(String key) 
  {
    if (_cache.containsKey(key)) 
    {
      return _cache[key];
    } else {
      return null;
    }
  }

  static bool hasData(String key) {
    return _cache.containsKey(key);
  }

  static void removeData(String key) {
    _cache.remove(key);
  }
}
