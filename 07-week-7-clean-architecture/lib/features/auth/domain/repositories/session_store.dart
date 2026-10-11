/// Kontrak penyimpanan sesi (token). Domain tidak tahu apa pun tentang
/// secure storage; implementasi Keychain/Keystore & memori ada di `data`.
abstract class SessionStore {
  Future<void> save({required String access, required String refresh});
  Future<String?> readAccess();
  Future<String?> readRefresh();
  Future<void> clear();
}
