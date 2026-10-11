import 'package:dio/dio.dart';

/// Error koneksi yang disengaja untuk mode offline deterministik.
class OfflineException implements Exception {
  const OfflineException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Pesan ramah pengguna untuk error jaringan/refresh.
String friendlyErrorMessage(Object error) {
  if (error is OfflineException) return error.message;
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi lambat atau timeout. Data cache tetap ditampilkan.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung. Data cache tetap ditampilkan.';
      default:
        return 'Refresh gagal. Data cache tetap ditampilkan.';
    }
  }
  return 'Refresh gagal: $error';
}
