/// Sesi hasil login: access pendek + refresh panjang.
class AuthSession {
  const AuthSession({required this.access, required this.refresh});

  final String access;
  final String refresh;
}

/// Mock auth yang siap diganti Firebase Auth.
/// GANTI titik ini dengan `FirebaseAuth.instance.signInWithEmailAndPassword`
/// saat backend Firebase sudah siap.
class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!email.contains('@') || password.length < 6) {
      throw Exception('Email atau kata sandi tidak valid');
    }
    return AuthSession(
      access: 'mock-access-for-$email',
      refresh: 'mock-refresh-for-$email',
    );
  }

  /// Tukar refresh menjadi access baru. Refresh mati -> lempar.
  Future<String> refresh(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (refreshToken.isEmpty) throw Exception('Refresh token hilang');
    if (refreshToken == 'refresh-mati') {
      throw Exception('Refresh token kedaluwarsa');
    }
    return 'mock-access-renewed-${DateTime.now().millisecondsSinceEpoch}';
  }
}
