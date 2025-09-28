class TtlCache<V> {
  final _store = <String, _Entry<V>>{};

  V? get(String key) {
    final e = _store[key];
    if (e == null) return null;
    if (DateTime.now().isAfter(e.expiresAt)) {
      _store.remove(key);
      return null;
    }
    return e.value;
  }

  void set(String key, V value, {Duration ttl = const Duration(minutes: 2)}) {
    _store[key] = _Entry(value, DateTime.now().add(ttl));
  }

  void invalidate(String key) => _store.remove(key);
  void clear() => _store.clear();
}

class _Entry<V> {
  final V value;
  final DateTime expiresAt;
  _Entry(this.value, this.expiresAt);
}

