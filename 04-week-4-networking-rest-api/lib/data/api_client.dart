import 'package:dio/dio.dart';

/// Klien HTTP terpusat: base URL, timeout 10 detik, interceptor logging.
/// `baseUrl` bisa ditimpa via --dart-define=API_BASE_URL=... untuk uji error.
Dio createDio({String? baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ??
          const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://jsonplaceholder.typicode.com',
          ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: false),
  );
  return dio;
}
