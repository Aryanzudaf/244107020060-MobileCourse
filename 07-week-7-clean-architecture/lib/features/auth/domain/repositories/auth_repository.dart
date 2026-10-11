import '../../../../core/failures.dart';
import '../entities/auth_session.dart';

/// Kontrak autentikasi yang dibutuhkan domain. Implementasi (mock/
/// Firebase Auth) hidup di `data`.
///
/// Hasil memakai record sukses/gagal sehingga exception tidak pernah
/// bocor ke presentation — UI hanya menerima [Failure.message].
abstract class AuthRepository {
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  });

  /// Tukar refresh menjadi access baru. Refresh mati -> `failure`.
  Future<({String? access, Failure? failure})> refresh(String refreshToken);
}
