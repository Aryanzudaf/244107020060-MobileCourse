import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/format.dart';
import '../../../../routes.dart';
import '../../domain/repositories/push_service.dart';

// ============================================================================
// Dependency injection
// ============================================================================

/// Push: Fake untuk web/demo/test, Firebase untuk perangkat asli.
final pushServiceProvider = Provider<PushService>((ref) {
  throw UnimplementedError('override dengan Firebase/Fake di main/test');
});

// ============================================================================
// Presentation state
// ============================================================================

/// Status izin + token + topik untuk UI (tanpa token penuh) + banner
/// foreground beserta tujuan deep link-nya.
class PushUiState {
  const PushUiState({
    this.permission = 'belum diminta',
    this.tokenPreview = '-',
    this.topic = '-',
    this.banner,
    this.bannerRoute,
  });

  final String permission;
  final String tokenPreview;
  final String topic;
  final String? banner;
  final String? bannerRoute;

  PushUiState copyWith({
    String? permission,
    String? tokenPreview,
    String? topic,
    String? banner,
    String? bannerRoute,
  }) {
    return PushUiState(
      permission: permission ?? this.permission,
      tokenPreview: tokenPreview ?? this.tokenPreview,
      topic: topic ?? this.topic,
      banner: banner,
      bannerRoute: bannerRoute,
    );
  }
}

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
    // Banner lewat kontrak (bukan cek tipe Fake) -> presentation bebas
    // dari dependensi ke data.
    push.onBanner =
        (title, body, route) => state = state.copyWith(
          banner: '$title: $body',
          bannerRoute: route,
        );
    // Demo screenshot: banner foreground otomatis setelah setup selesai.
    // `&route=` opsional memilih tujuan deep link (default /pengumuman/3),
    // mis. `/pengumuman/99` untuk memotret state NotFoundFailure.
    if (Uri.base.queryParameters['banner'] == '1') {
      await push.simulateIncoming(
        Uri.base.queryParameters['route'] ?? AppRoutes.announcement('3'),
      );
    }
  }

  void dismissBanner() =>
      state = state.copyWith(banner: null, bannerRoute: null);
}

final pushUiProvider =
    NotifierProvider<PushUiNotifier, PushUiState>(PushUiNotifier.new);
