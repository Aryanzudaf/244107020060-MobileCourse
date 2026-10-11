import '../../../core/failures.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';
import 'api_errors.dart';

/// Implementasi data dengan backend mock.
/// GANTI titik ini dengan `FirebaseAuth.signInWithEmailAndPassword`
/// saat backend Firebase siap.
///
/// Exception mentah (termasuk `DioException` di versi remote) ditangkap
/// di BATAS data lalu diubah menjadi [Failure] sebelum result keluar.
class AuthRepositoryMock implements AuthRepository {
  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return (
        session: AuthSession(
          access: 'mock-access-for-$email',
          refresh: 'mock-refresh-for-$email',
        ),
        failure: null,
      );
    } catch (e) {
      return (session: null, failure: apiFailure(e));
    }
  }

  @override
  Future<({String? access, Failure? failure})> refresh(
    String refreshToken,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      if (refreshToken.isEmpty) {
        return (
          access: null,
          failure: const AuthFailure('Refresh token hilang'),
        );
      }
      if (refreshToken == 'refresh-mati') {
        return (
          access: null,
          failure: const AuthFailure('Refresh token kedaluwarsa'),
        );
      }
      return (
        access: 'mock-access-renewed-${DateTime.now().millisecondsSinceEpoch}',
        failure: null,
      );
    } catch (e) {
      return (access: null, failure: apiFailure(e));
    }
  }
}
