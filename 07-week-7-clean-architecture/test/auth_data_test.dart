import 'package:campus_notify/core/failures.dart';
import 'package:campus_notify/features/auth/data/api_client.dart';
import 'package:campus_notify/features/auth/data/api_errors.dart';
import 'package:campus_notify/features/auth/data/auth_repository_mock.dart';
import 'package:campus_notify/features/auth/data/session_store_impl.dart';
import 'package:campus_notify/features/auth/domain/entities/auth_session.dart';
import 'package:campus_notify/features/auth/domain/repositories/auth_repository.dart';
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
  test('MemorySessionStore simpan-baca-hapus', () async {
    final store = MemorySessionStore();
    await store.save(access: 'a1', refresh: 'r1');
    expect(await store.readAccess(), 'a1');
    expect(await store.readRefresh(), 'r1');
    await store.clear();
    expect(await store.readAccess(), isNull);
  });

  test('AuthRepositoryMock menukar sesi untuk kredensial valid', () async {
    final repo = AuthRepositoryMock();
    final result = await repo.login(
      email: 'aryan@student.polinema.ac.id',
      password: 'rahasia123',
    );
    expect(result.failure, isNull);
    expect(result.session!.access, contains('mock-access'));
  });

  test('refresh mati menghasilkan failure tanpa melempar', () async {
    final repo = AuthRepositoryMock();
    final dead = await repo.refresh('refresh-mati');
    expect(dead.access, isNull);
    expect(dead.failure, isA<AuthFailure>());
    final ok = await repo.refresh('mock-refresh-ok');
    expect(ok.failure, isNull);
    expect(ok.access, contains('mock-access-renewed'));
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
    final store = MemorySessionStore();
    await store.save(access: 'basi', refresh: 'segar');
    final dio = buildApiClient(
      store,
      _OkRefreshAuth(),
      baseUrl: 'https://tes.test',
    );
    dio.httpClientAdapter = _StubAdapter([
      (o) => ResponseBody.fromString('unauthorized', 401),
      (o) => ResponseBody.fromString('{"ok":true}', 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      }),
    ]);

    final res = await dio.get('/data');
    expect(res.statusCode, 200);
    expect(await store.readAccess(), isNotNull);
  });

  test('refresh ditolak -> sesi dibersihkan + onRefreshFailed dipanggil', () async {
    final store = MemorySessionStore();
    await store.save(access: 'basi', refresh: 'refresh-mati');
    var loggedOut = false;
    final dio = buildApiClient(
      store,
      AuthRepositoryMock(),
      baseUrl: 'https://tes.test',
      onRefreshFailed: () async => loggedOut = true,
    );
    dio.httpClientAdapter = _StubAdapter([
      (o) => ResponseBody.fromString('unauthorized', 401),
    ]);

    await expectLater(dio.get('/data'), throwsA(isA<DioException>()));
    expect(await store.readAccess(), isNull);
    expect(loggedOut, isTrue);
  });
}

class _OkRefreshAuth implements AuthRepository {
  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async =>
      (
        session: null,
        failure: const AuthFailure('tidak dipakai di test ini'),
      );

  @override
  Future<({String? access, Failure? failure})> refresh(
    String refreshToken,
  ) async =>
      (access: 'baru-123', failure: null);
}
