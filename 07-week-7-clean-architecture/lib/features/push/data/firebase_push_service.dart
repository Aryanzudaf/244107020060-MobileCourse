import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/format.dart';
import '../domain/repositories/push_service.dart';

/// Handler background WAJIB top-level (isolate terpisah).
/// Tanpa BuildContext/Riverpod: hanya catat ringan.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG: ${message.messageId}');
}

final _local = FlutterLocalNotificationsPlugin();

/// Implementasi Firebase asli (perangkat). Semua panggilan aman bila
/// Firebase belum terkonfigurasi (lempar -> ditangkap pemanggil).
///
/// Android 13+ butuh izin runtime `POST_NOTIFICATIONS`; iOS butuh
/// capability Push Notifications + APNs. Perbedaan ini didokumentasikan,
/// bukan dicabangkan di kode demo.
class FirebasePushService implements PushService {
  void Function(String title, String body, String route)? _onBanner;

  @override
  set onBanner(void Function(String title, String body, String route) handler) {
    _onBanner = handler;
  }

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
      _onBanner?.call(
        message.notification?.title ?? 'Pengumuman',
        message.notification?.body ?? '',
        route,
      );
    });
  }

  @override
  Future<void> simulateIncoming(String route) async {
    _onBanner?.call('Demo', 'Simulasi di Firebase tidak tersedia.', route);
  }
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
  );
}
