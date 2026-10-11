import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/preview_fakes.dart';
import 'data/providers.dart';
import 'pages/note_detail_page.dart';
import 'pages/notes_page.dart';
import 'pages/posts_page.dart';
import 'pages/settings_page.dart';

/// `?demo=seed` contoh catatan (2 dirty), `?demo=clean` (0 dirty),
/// `?demo=cachefail` refresh selalu gagal (bukti cache tetap tampil).
void main() {
  final demo = Uri.base.queryParameters['demo'];
  runApp(
    ProviderScope(
      overrides: [
        if (demo == 'seed')
          noteRepositoryProvider
              .overrideWithValue(SeedNoteRepository()),
        if (demo == 'clean')
          noteRepositoryProvider.overrideWithValue(
            SeedNoteRepository(dirty: false),
          ),
        if (demo == 'cachefail')
          postRepositoryProvider
              .overrideWithValue(ThrowingPostRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

/// `/` catatan, `/settings` pengaturan, `/posts` data API,
/// `/note/:id` detail dari repository lokal.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) => const PostsPage(),
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) => NoteDetailPage(
        id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
      ),
    ),
  ],
);

/// Tema mengikuti preferensi tersimpan (SharedPreferences),
/// atau dipaksa via `?theme=dark|light` (demo web).
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(darkModeProvider).value ?? false;
    final query = Uri.base.queryParameters['theme'];
    final dark = query == 'dark' || (query != 'light' && saved);
    return MaterialApp.router(
      title: 'Week 5 - Offline Notes',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
