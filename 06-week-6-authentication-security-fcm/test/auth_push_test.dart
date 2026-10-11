import 'dart:async';

import 'package:campus_notify/data/api_client.dart';
import 'package:campus_notify/data/api_errors.dart';
import 'package:campus_notify/data/auth_repository.dart';
import 'package:campus_notify/data/token_store.dart';
import 'package:campus_notify/messaging/push_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adapter Dio stub: antrean respons tanpa HTTP sungguhan.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._script);

  final List<ResponseBody Function(RequestOptions)> _script;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final fn = _script[calls < _script.length ? calls++ : _script.length - 1];
    return fn(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('routeFromMessage menangani route kosong dan tanpa slash', () {
    expect(routeFromMessage({}), '/');
    expect(routeFromMessage({'route': 'pengumuman/3'}), '/pengumuman/3');
    expect(routeFromMessage({'route': '/pengumuman/3'}), '/pengumuman/3');
  });

  test('data payload membawa id pengumuman', () {
    const data = {'route': '/pengumuman/3', 'id': '3'};
    expect(data['id'], '3');
    expect(routeFromMessage(data), '/pengumuman/3');
  });

  test('tokenPreview memotong 12 karakter', () {
    expect(tokenPreview('demo-fcm-token-abcdef123456'), 'demo-fcm-tok...');
    expect(tokenPreview('pendek'), 'pendek...');
    expect(tokenPreview(null), '-');
  });

  test('TokenStore memori simpan-baca-hapus', () async {
    final store = TokenStore(backend: MemoryTokenBackend());
    await store.save(access: 'a1', refresh: 'r1');
    expect(await store.readAccess(), 'a1');
    expect(await store.readRefresh(), 'r1');
    await store.clear();
    expect(await store.readAccess(), isNull);
  });

  test('login mock menolak kredensial buruk', () async {
    final auth = AuthRepository();
    await expectLater(
      auth.login(email: 'salah', password: '123'),
      throwsA(isA<Exception>()),
    );
    final session = await auth.login(
      email: 'aryan@student.polinema.ac.id',
      password: 'rahasia123',
    );
    expect(session.access, contains('mock-access'));
  });

  test('refresh mati melempar (sesi harus dibersihkan)', () async {
    final auth = AuthRepository();
    await expectLater(auth.refresh('refresh-mati'), throwsA(isA<Exception>()));
    final renewed = await auth.refresh('mock-refresh-ok');
    expect(renewed, contains('mock-access-renewed'));
  });

  test('apiErrorMessage memetakan 401 dan timeout', () {
    final e401 = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 401,
      ),
    );
    expect(apiErrorMessage(e401), contains('login ulang'));
    final timeout = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.connectionTimeout,
    );
    expect(apiErrorMessage(timeout), contains('timeout'));
  });

  test('401 memicu refresh sekali lalu retry sukses', () async {
    final store = TokenStore(backend: MemoryTokenBackend());
    await store.save(access: 'basi', refresh: 'segar');
    final dio = buildApiClient(store, _OkRefreshAuth(),
        baseUrl: 'https://tes.test');
    // Simulasikan: request pertama 401, retry 200.
    var first = true;
    dio.httpClientAdapter = _StubAdapter([
      (o) {
        first = false;
        return ResponseBody.fromString('unauthorized', 401);
      },
      (o) => ResponseBody.fromString('{"ok":true}', 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      }),
    ]);

    final res = await dio.get('/data');
    expect(first, false);
    expect(res.statusCode, 200);
    expect(await store.readAccess(), isNotNull);
  });

  test('FakePushService mencatat token dan topik', () async {
    final fake = FakePushService();
    expect(await fake.requestPermission(), 'authorized');
    await fake.initToken((_) async {});
    await fake.subscribeTopic('pengumuman-kampus');
    expect(fake.lastTokenSent, contains('demo-fcm-token'));
    expect(fake.topicSubscribed, 'pengumuman-kampus');
  });
}

class _OkRefreshAuth extends AuthRepository {
  @override
  Future<String> refresh(String refreshToken) async => 'baru-123';
}
