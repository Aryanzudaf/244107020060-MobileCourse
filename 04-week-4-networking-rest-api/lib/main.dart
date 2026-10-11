import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/models/post.dart';
import 'data/preview_fakes.dart';
import 'data/providers.dart';
import 'pages/paged_post_page.dart';
import 'pages/post_detail_page.dart';
import 'pages/post_list_page.dart';

/// `?demo=seed|error|empty` (web) mengganti repository dengan fakes
/// agar screenshot deterministik tanpa HTTP.
void main() {
  final demo = Uri.base.queryParameters['demo'];
  runApp(
    ProviderScope(
      overrides: [
        if (demo == 'seed') ...[
          postRepositoryProvider.overrideWithValue(SeedPostRepository()),
          commentRepositoryProvider
              .overrideWithValue(SeedCommentRepository()),
        ],
        if (demo == 'error')
          postRepositoryProvider.overrideWithValue(ErrorPostRepository()),
        if (demo == 'empty')
          postRepositoryProvider.overrideWithValue(EmptyPostRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

/// `/` paged, `/simple` daftar penuh, `/post/:id` detail + komentar.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PagedPostPage(),
    ),
    GoRoute(
      path: '/simple',
      builder: (context, state) => const PostListPage(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        final initial = state.extra;
        return PostDetailPage(
          id: id,
          initial: initial is Post ? initial : null,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Week 4 - REST API',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    );
  }
}
