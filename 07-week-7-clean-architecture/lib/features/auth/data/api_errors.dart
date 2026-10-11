import 'package:dio/dio.dart';

import '../../../core/failures.dart';

/// `DioException`/exception mentah -> pesan ramah.
/// Hanya dipakai di data layer; presentation tidak mengenal Dio.
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
  return errorMessage(error);
}

/// Konversi exception mentah -> [Failure] di batas data, dipanggil oleh
/// repository sebelum result sampai ke presentation.
Failure apiFailure(Object error) => NetworkFailure(apiErrorMessage(error));
