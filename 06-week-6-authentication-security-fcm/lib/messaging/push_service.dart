import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Fungsi murni: data payload -> rute deep link. Bisa diunit-test
/// tanpa Firebase. Selalu kembalikan path ber-slash.
String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route']?.toString() ?? '/';
  return route.startsWith('/') ? route : '/$route';
}

/// Handler background WAJIB top-level (isolate terpisah).
/// Tanpa BuildContext/Riverpod: hanya catat ringan.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG: ${message.messageId}');
}

final _local = FlutterLocalNotificationsPlugin();

/// Status izin + token + topik untuk UI (tanpa token penuh).
class PushUiState {
  const PushUiState({
    this.permission = 'belum diminta',
    this.tokenPreview = '-',
    this.topic = '-',
    this.banner,
  });

  final String permission;
  final String tokenPreview;
  final String topic;
  final String? banner;

  PushUiState copyWith({
    String? permission,
    String? tokenPreview,
    String? topic,
    String? banner,
  }) {
    return PushUiState(
      permission: permission ?? this.permission,
      tokenPreview: tokenPreview ?? this.tokenPreview,
      topic: topic ?? this.topic,
      banner: banner,
    );
  }
}

/// Kontrak push agar web/demo/test bisa memakai Fake.
abstract class PushService {
  Future<String> requestPermission();
  Future<void> initToken(Future<void> Function(String token) onToken);
  Future<void> subscribeTopic(String topic);
  Future<void> simulateIncoming(String route);
}

/// Implementasi Firebase asli. Semua panggilan aman bila Firebase
/// belum terkonfigurasi (lempar -> ditangkap pemanggil).
class FirebasePushService implements PushService {
  FirebasePushService({required this.onForegroundBanner});

  final void Function(String title, String body, String route)
      onForegroundBanner;

  @override
  Future<String> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus.name;
  }

  @override
  Future<void> initToken(Future<void> Function(String token) onToken) async {
    // 1. Token saat ini -> backend (POST /devices).
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await onToken(token);
    // 2. Token bisa basi (reinstall/clear data/rotasi) -> wajib pantau.
    FirebaseMessaging.instance.onTokenRefresh.listen(onToken);
  }

  @override
  Future<void> subscribeTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  void listenForeground() {
    // Foreground: sistem TIDAK menampilkan banner -> manual.
    FirebaseMessaging.onMessage.listen((message) async {
      final route = routeFromMessage(message.data);
      const android = AndroidNotificationDetails(
        'pengumuman',
        'Pengumuman Kampus',
        importance: Importance.high,
        priority: Priority.high,
      );
      await _local.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(android: android),
        payload: route,
      );
      onForegroundBanner(
        message.notification?.title ?? 'Pengumuman',
        message.notification?.body ?? '',
        route,
      );
    });
  }

  /// Android 13+ butuh izin runtime; iOS butuh APNs + capability Push.
  /// Perbedaan ini didokumentasikan, bukan dicabangkan di kode demo.
  @override
  Future<void> simulateIncoming(String route) async {
    onForegroundBanner('Demo', 'Simulasi di Firebase tidak tersedia.', route);
  }
}

/// Fake deterministik untuk web/demo/test (tanpa Firebase).
class FakePushService implements PushService {
  FakePushService({this.onBanner});

  void Function(String route)? onBanner;
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
  Future<void> simulateIncoming(String route) async => onBanner?.call(route);
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
  );
}
