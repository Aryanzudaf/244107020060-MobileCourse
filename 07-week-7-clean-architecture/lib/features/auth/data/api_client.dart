import 'package:dio/dio.dart';

import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/session_store.dart';

/// Dio dengan refresh otomatis: 401 -> tukar refresh SEKALI -> ulangi
/// request. Refresh ditolak -> [onRefreshFailed] (logout + ke /login).
///
/// Bergantung pada kontrak domain ([SessionStore], [AuthRepository]),
/// bukan pada implementasinya — data layer boleh mengarah ke dalam.
Dio buildApiClient(
  SessionStore store,
  AuthRepository auth, {
  Future<void> Function()? onRefreshFailed,
  String? baseUrl,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://example-campus-api.test',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401 && !_retried(e.requestOptions)) {
          final refresh = await store.readRefresh();
          if (refresh == null) return handler.next(e);

          // 1) Tukar refresh (kontrak record: tidak ada exception bocor).
          String? renewed;
          try {
            final result = await auth.refresh(refresh);
            renewed = result.failure == null ? result.access : null;
            if (renewed != null) {
              await store.save(access: renewed, refresh: refresh);
            }
          } catch (_) {
            renewed = null; // kontrak: repository tidak melempar; tetap aman
          }

          // 2) Retry sekali saja (flag `__retried`).
          if (renewed != null) {
            try {
              final options = e.requestOptions
                ..headers['Authorization'] = 'Bearer $renewed';
              options.extra['__retried'] = true;
              final retry = await dio.fetch(options);
              return handler.resolve(retry);
            } catch (_) {
              // Retry ikut gagal -> jatuh ke pembersihan sesi di bawah.
            }
          }

          // 3) Refresh ditolak/gagal -> sesi dibersihkan + logout.
          await store.clear();
          await onRefreshFailed?.call();
        }
        handler.next(e);
      },
    ),
  );
  return dio;
}

bool _retried(RequestOptions options) => options.extra['__retried'] == true;
