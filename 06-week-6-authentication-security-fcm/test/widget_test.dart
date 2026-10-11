import 'package:campus_notify/data/token_store.dart';
import 'package:campus_notify/main.dart';
import 'package:campus_notify/messaging/push_service.dart';
import 'package:campus_notify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderScope _demoScope({required bool loggedIn}) {
  final store = TokenStore(backend: MemoryTokenBackend());
  return ProviderScope(
    overrides: [
      tokenStoreProvider.overrideWithValue(store),
      pushServiceProvider.overrideWithValue(FakePushService()),
    ],
    child: _SeedLogin(loggedIn: loggedIn),
  );
}

/// Menyimpan sesi demo sebelum app dibangun.
class _SeedLogin extends ConsumerStatefulWidget {
  const _SeedLogin({required this.loggedIn});

  final bool loggedIn;

  @override
  ConsumerState<_SeedLogin> createState() => _SeedLoginState();
}

class _SeedLoginState extends ConsumerState<_SeedLogin> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.loggedIn) {
        await ref
            .read(tokenStoreProvider)
            .save(access: 'demo-access', refresh: 'demo-refresh');
        ref.invalidate(authStateProvider);
      }
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return const CampusNotifyApp();
  }
}

void main() {
  testWidgets('login menampilkan error untuk kredensial buruk', (
    tester,
  ) async {
    await tester.pumpWidget(_demoScope(loggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('Masuk Kampus'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'salah');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.textContaining('tidak valid'), findsOneWidget);
  });

  testWidgets('beranda menampilkan token terpotong + topik', (tester) async {
    await tester.pumpWidget(_demoScope(loggedIn: true));
    await tester.pumpAndSettle();

    expect(find.text('Pengumuman Kampus'), findsOneWidget);
    expect(find.text('demo-fcm-tok...'), findsOneWidget);
    expect(find.text('pengumuman-kampus'), findsOneWidget);
  });

  testWidgets('banner foreground diklik menuju pengumuman', (tester) async {
    await tester.pumpWidget(_demoScope(loggedIn: true));
    await tester.pumpAndSettle();

    // Simulasi push masuk seperti FakePushService demo.
    final context = tester.element(find.text('Pengumuman Kampus'));
    final container =
        ProviderScope.containerOf(context, listen: false);
    final fake =
        container.read(pushServiceProvider) as FakePushService;
    fake.onBanner = (_) {};
    container.read(pushUiProvider.notifier).setup();
    await tester.pumpAndSettle();
    await container
        .read(pushServiceProvider)
        .simulateIncoming('/pengumuman/3');
    await tester.pumpAndSettle();

    expect(find.textContaining('Jadwal kuliah berubah'), findsWidgets);
  });
}
