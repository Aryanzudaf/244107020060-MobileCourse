import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/repositories/session_store.dart';

/// Produksi: token disimpan di Keychain (iOS) / Keystore (Android).
class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  @override
  Future<String?> readAccess() => _storage.read(key: _accessKey);

  @override
  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  @override
  Future<void> clear() => _storage.deleteAll();
}

/// Web/demo/test: memori (hilang saat proses berakhir).
class MemorySessionStore implements SessionStore {
  final _map = <String, String>{};

  @override
  Future<void> save({required String access, required String refresh}) async {
    _map[SessionStoreKey.access] = access;
    _map[SessionStoreKey.refresh] = refresh;
  }

  @override
  Future<String?> readAccess() async => _map[SessionStoreKey.access];

  @override
  Future<String?> readRefresh() async => _map[SessionStoreKey.refresh];

  @override
  Future<void> clear() async => _map.clear();
}

/// Kunci penyimpanan (sama untuk kedua backend).
abstract final class SessionStoreKey {
  static const access = 'access_token';
  static const refresh = 'refresh_token';
}
