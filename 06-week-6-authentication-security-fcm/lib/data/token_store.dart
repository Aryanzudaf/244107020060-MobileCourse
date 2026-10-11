import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Backend penyimpanan token. Produksi memakai secure storage
/// (Keychain/Keystore); web/demo/test memakai memori.
abstract class TokenBackend {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> clear();
}

class SecureTokenBackend implements TokenBackend {
  SecureTokenBackend([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}

class MemoryTokenBackend implements TokenBackend {
  final _map = <String, String>{};

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> clear() async => _map.clear();
}

/// Satu-satunya pintu keluar-masuk token.
class TokenStore {
  TokenStore({TokenBackend? backend})
      : _backend = backend ?? SecureTokenBackend();

  final TokenBackend _backend;
  static const accessKey = 'access_token';
  static const refreshKey = 'refresh_token';

  Future<void> save({required String access, required String refresh}) async {
    await _backend.write(accessKey, access);
    await _backend.write(refreshKey, refresh);
  }

  Future<String?> readAccess() => _backend.read(accessKey);
  Future<String?> readRefresh() => _backend.read(refreshKey);
  Future<void> clear() => _backend.clear();
}

/// Token penuh tidak pernah tampil di UI/log: 12 karakter pertama + `...`.
String tokenPreview(String? token) {
  if (token == null || token.isEmpty) return '-';
  final head = token.length <= 12 ? token : token.substring(0, 12);
  return '$head...';
}
