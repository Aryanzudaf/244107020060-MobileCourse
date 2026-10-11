/// Sesi hasil login: access pendek + refresh panjang.
/// Entity murni — tanpa `toMap/fromJson`; hidup di domain.
class AuthSession {
  const AuthSession({required this.access, required this.refresh});

  final String access;
  final String refresh;
}
