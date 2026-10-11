import 'package:dio/dio.dart';

import 'auth_repository.dart';
import 'token_store.dart';

/// Dio dengan refresh otomatis: 401 -> tukar refresh SEKALI -> ulangi
/// request. Refresh mati -> [onRefreshFailed] (logout + ke /login).
Dio buildApiClient(
  TokenStore store,
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
          try {
            final renewed = await auth.refresh(refresh);
            await store.save(access: renewed, refresh: refresh);
            final options = e.requestOptions
              ..headers['Authorization'] = 'Bearer $renewed';
            options.extra['__retried'] = true;
            final retry = await dio.fetch(options);
            return handler.resolve(retry);
          } catch (_) {
            await store.clear();
            await onRefreshFailed?.call();
          }
        }
        handler.next(e);
      },
    ),
  );
  return dio;
}

bool _retried(RequestOptions options) =>
    options.extra['__retried'] == true;
