import 'package:dio/dio.dart';

/// `DioException` -> pesan ramah. UI hanya menerima string, bukan exception.
String apiErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa internet Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) return 'Sesi berakhir. Silakan login ulang.';
        if (code == 404) return 'Data tidak ditemukan (404).';
        return 'Server bermasalah ($code). Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }
  return error.toString().replaceFirst('Exception: ', '');
}
