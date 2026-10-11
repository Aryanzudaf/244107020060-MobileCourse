import '../../../../core/failures.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Satu operasi bisnis: validasi kredensial + minta sesi ke repository.
///
/// Validasi dipindahkan ke sini (aturan bisnis) — bukan widget, bukan
/// data — sehingga bisa diunit-test tanpa backend.
class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<({AuthSession? session, Failure? failure})> call({
    required String email,
    required String password,
  }) async {
    if (!email.contains('@') || password.length < 6) {
      return (
        session: null,
        failure: const AuthFailure('Email atau kata sandi tidak valid'),
      );
    }
    return _repository.login(email: email, password: password);
  }
}
