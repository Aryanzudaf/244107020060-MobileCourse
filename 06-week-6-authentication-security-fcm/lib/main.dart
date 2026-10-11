import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/token_store.dart';
import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';

/// Firebase guarded init: tanpa `google-services.json` (demo),
/// aplikasi tetap jalan dengan FakePushService.
///
/// Mode demo web (`?demo=`): `login` (belum login), `home`/`banner`
/// (sudah login, token memori + FakePush). `?banner=1` memunculkan
/// banner foreground otomatis untuk screenshot.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  } catch (_) {
    debugPrint('Firebase tidak terkonfigurasi: mode demo.');
  }

  final demo = Uri.base.queryParameters['demo'];
  if (demo == null) {
    runApp(const ProviderScope(child: CampusNotifyApp()));
    return;
  }
  final store = TokenStore(backend: MemoryTokenBackend());
  if (demo != 'login') {
    await store.save(access: 'demo-access', refresh: 'demo-refresh');
  }
  runApp(
    ProviderScope(
      overrides: [
        tokenStoreProvider.overrideWithValue(store),
        pushServiceProvider.overrideWithValue(FakePushService()),
      ],
      child: const CampusNotifyApp(),
    ),
  );
}

class CampusNotifyApp extends ConsumerStatefulWidget {
  const CampusNotifyApp({super.key});

  @override
  ConsumerState<CampusNotifyApp> createState() => _CampusNotifyAppState();
}

class _CampusNotifyAppState extends ConsumerState<CampusNotifyApp> {
  GoRouter? _router;
  bool? _loggedIn;

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(authStateProvider).value ?? false;
    // Router di-cache: dibuat ulang hanya saat status login berubah,
    // agar state navigasi tidak hilang setiap rebuild.
    if (_router == null || _loggedIn != loggedIn) {
      _loggedIn = loggedIn;
      _router = GoRouter(
        initialLocation: AppRoutes.home,
        redirect: (context, state) {
          final goingLogin = state.matchedLocation == AppRoutes.login;
          if (!loggedIn && !goingLogin) return AppRoutes.login;
          if (loggedIn && goingLogin) return AppRoutes.home;
          return null;
        },
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.announcementDetail,
            builder: (context, state) => AnnouncementPage(
              id: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      );
    }

    return MaterialApp.router(
      title: 'Week 6 - Campus Notify',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    );
  }
}

/// Catatan: entri demo sudah digabung ke `main()` via `?demo=`.
