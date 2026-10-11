/// Kegagalan domain: pesan ramah untuk UI tanpa exception bocor ke
/// presentation. Murni Dart — tanpa import Flutter/Dio/SQLite/Firebase
/// (aturan dependensi: `lib/core` wajib steril dari framework).
library;

sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// Jaringan/remote (timeout, 401, server) — dipetakan di data layer.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Penyimpanan lokal (secure storage, database).
class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

/// Autentikasi ditolak (kredensial/sesi kedaluwarsa).
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Data tidak ditemukan.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Error apa pun -> teks ramah untuk UI. [Failure] memakai `message`-nya
/// sendiri; objek lain dibersihkan dari awalan `Exception: `.
String errorMessage(Object error) => error is Failure
    ? error.message
    : error.toString().replaceFirst('Exception: ', '');
