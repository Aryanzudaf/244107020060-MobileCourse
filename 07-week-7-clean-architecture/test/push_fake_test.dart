import 'package:campus_notify/features/push/data/fake_push_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FakePushService mencatat token dan topik', () async {
    final fake = FakePushService();
    expect(await fake.requestPermission(), 'authorized');
    await fake.initToken((_) async {});
    await fake.subscribeTopic('pengumuman-kampus');
    expect(fake.lastTokenSent, contains('demo-fcm-token'));
    expect(fake.topicSubscribed, 'pengumuman-kampus');
  });

  test('FakePushService meneruskan tujuan deep link ke banner', () async {
    final fake = FakePushService();
    String? seenRoute;
    String? seenTitle;
    fake.onBanner = (title, body, route) {
      seenTitle = title;
      seenRoute = route;
    };
    await fake.simulateIncoming('/pengumuman/3');
    expect(seenTitle, 'Jadwal kuliah berubah');
    expect(seenRoute, '/pengumuman/3');
  });
}
