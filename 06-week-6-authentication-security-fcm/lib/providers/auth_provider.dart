import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/auth_repository.dart';
import '../data/token_store.dart';
import '../messaging/push_service.dart';
import '../routes.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final apiClientProvider = Provider<Dio>((ref) {
  final store = ref.watch(tokenStoreProvider);
  final auth = ref.watch(authRepositoryProvider);
  return buildApiClient(
    store,
    auth,
    onRefreshFailed: () => ref.read(authStateProvider.notifier).logout(),
  );
});

/// true = sudah login (ada access token).
class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.watch(tokenStoreProvider).readAccess();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(tokenStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    ref.invalidateSelf();
  }
}

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

/// Push: Fake untuk web/demo/test, Firebase untuk perangkat asli.
final pushServiceProvider = Provider<PushService>((ref) {
  throw UnimplementedError('override dengan Firebase/Fake di main/test');
});

class PushUiNotifier extends Notifier<PushUiState> {
  @override
  PushUiState build() => const PushUiState();

  Future<void> setup() async {
    final push = ref.read(pushServiceProvider);
    final permission = await push.requestPermission();
    var preview = '-';
    await push.initToken((token) async {
      // POST /devices didokumentasikan di README (tanpa backend nyata).
      preview = tokenPreview(token);
    });
    await push.subscribeTopic(PushConfig.topic);
    state = state.copyWith(
      permission: permission,
      tokenPreview: preview,
      topic: PushConfig.topic,
    );
    final svc = push;
    if (svc is FakePushService) {
      svc.onBanner = (route) =>
          state = state.copyWith(banner: 'Jadwal kuliah berubah: $route');
      // Demo screenshot: banner otomatis setelah setup selesai (tanpa race).
      if (Uri.base.queryParameters['banner'] == '1') {
        await svc.simulateIncoming(AppRoutes.announcement('3'));
      }
    }
  }

  void dismissBanner() => state = state.copyWith(banner: null);
}

final pushUiProvider =
    NotifierProvider<PushUiNotifier, PushUiState>(PushUiNotifier.new);
