import 'package:campus_notify/core/failures.dart';
import 'package:campus_notify/features/auth/domain/entities/auth_session.dart';
import 'package:campus_notify/features/auth/domain/repositories/auth_repository.dart';
import 'package:campus_notify/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repository palsu: tanpa backend, tanpa jaringan (uji murni domain).
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.fail = false});

  final bool fail;
  var loginCalls = 0;

  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    if (fail) {
      return (
        session: null,
        failure: const AuthFailure('Backend menolak (simulasi)'),
      );
    }
    return (
      session: const AuthSession(access: 'a1', refresh: 'r1'),
      failure: null,
    );
  }

  @override
  Future<({String? access, Failure? failure})> refresh(
    String refreshToken,
  ) async =>
      (access: 'x', failure: null);
}

void main() {
  test('Login meneruskan sesi dari repository', () async {
    final repo = _FakeAuthRepository();
    final result = await Login(repo).call(
      email: 'aryan@student.polinema.ac.id',
      password: 'rahasia123',
    );
    expect(result.failure, isNull);
    expect(result.session!.access, 'a1');
    expect(repo.loginCalls, 1);
  });

  test('Login menolak kredensial buruk tanpa memanggil repository', () async {
    final repo = _FakeAuthRepository();
    final result = await Login(repo).call(email: 'salah', password: '123');
    expect(result.session, isNull);
    expect(result.failure, isA<AuthFailure>());
    expect(result.failure!.message, contains('tidak valid'));
    expect(repo.loginCalls, 0);
  });

  test('Login meneruskan failure repository tanpa melempar', () async {
    final repo = _FakeAuthRepository(fail: true);
    final result = await Login(repo).call(
      email: 'a@b.c',
      password: 'rahasia123',
    );
    expect(result.session, isNull);
    expect(result.failure, isA<AuthFailure>());
    expect(result.failure!.message, contains('Backend menolak'));
  });
}
