/// Kontrak push yang dibutuhkan presentation. Implementasi Firebase
/// (perangkat asli) dan Fake (web/demo/test) hidup di `data`.
///
/// Domain bebas Firebase — lihat `firebase_push_service.dart`.
abstract class PushService {
  Future<String> requestPermission();

  /// Token perangkat -> backend (`POST /devices`) lewat [onToken].
  Future<void> initToken(Future<void> Function(String token) onToken);

  Future<void> subscribeTopic(String topic);

  /// Simulasi notifikasi masuk (dipakai demo/screenshot).
  Future<void> simulateIncoming(String route);

  /// Banner foreground: (judul, isi, tujuan deep link).
  set onBanner(void Function(String title, String body, String route) handler);
}
