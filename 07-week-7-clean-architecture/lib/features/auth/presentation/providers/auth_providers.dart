import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failures.dart';
import '../../data/api_client.dart';
import '../../data/auth_repository_mock.dart';
import '../../data/session_store_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/session_store.dart';
import '../../domain/usecases/login.dart';

// ============================================================================
// Dependency injection: SATU-SATUNYA tempat wiring. Widget tidak pernah
// menginstansiasi repository/use case sendiri.
// ============================================================================

/// Sesi token: Keychain/Keystore (produksi). Test/demo override dengan
/// [MemorySessionStore].
final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SecureSessionStore(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryMock(),
);

/// Domain: use case menerima abstraksi, bukan implementasi.
final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);

/// Data: Dio + interceptor refresh-sekali (dipakai panggilan API berikutnya).
final apiClientProvider = Provider<Dio>((ref) {
  final store = ref.watch(sessionStoreProvider);
  final auth = ref.watch(authRepositoryProvider);
  return buildApiClient(
    store,
    auth,
    onRefreshFailed: () => ref.read(authStateProvider.notifier).logout(),
  );
});

// ============================================================================
// Presentation state
// ============================================================================

/// true = sudah login (ada access token).
class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.watch(sessionStoreProvider).readAccess();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref.read(loginUseCaseProvider)(
      email: email,
      password: password,
    );
    final session = result.session;
    if (session == null) {
      // UI hanya menerima Failure (pesan ramah), bukan exception mentah.
      state = AsyncError(
        result.failure ?? const AuthFailure('Login gagal.'),
        StackTrace.current,
      );
      return;
    }
    try {
      await ref
          .read(sessionStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(
        LocalFailure('Gagal menyimpan sesi: $e'),
        StackTrace.current,
      );
    }
  }

  Future<void> logout() async {
    await ref.read(sessionStoreProvider).clear();
    ref.invalidateSelf();
  }
}

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
