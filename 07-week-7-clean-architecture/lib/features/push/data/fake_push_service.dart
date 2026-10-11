import '../domain/repositories/push_service.dart';

/// Fake deterministik untuk web/demo/test (tanpa Firebase).
class FakePushService implements PushService {
  void Function(String title, String body, String route)? _onBanner;

  @override
  set onBanner(void Function(String title, String body, String route) handler) {
    _onBanner = handler;
  }

  String? lastTokenSent;
  String? topicSubscribed;
  var permissionRequested = false;

  @override
  Future<String> requestPermission() async {
    permissionRequested = true;
    return 'authorized';
  }

  @override
  Future<void> initToken(Future<void> Function(String token) onToken) async {
    const token = 'demo-fcm-token-abcdef123456';
    await onToken(token); // -> POST /devices (didokumentasikan)
    lastTokenSent = token;
  }

  @override
  Future<void> subscribeTopic(String topic) async {
    topicSubscribed = topic;
  }

  @override
  Future<void> simulateIncoming(String route) async {
    // Teks statis; isi = tujuan deep link agar rute target terlihat di
    // banner/screenshot.
    _onBanner?.call('Jadwal kuliah berubah', route, route);
  }
}
