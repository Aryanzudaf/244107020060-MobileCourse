import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:week4_api/data/providers.dart';
import 'package:week4_api/pages/paged_post_page.dart';
import 'package:week4_api/pages/post_list_page.dart';
import 'package:week4_api/widgets/post_tile.dart';

import 'fakes.dart';

const _sample = [
  Post(userId: 1, id: 1, title: 'Judul uji', body: 'Isi uji baris satu.'),
];

void main() {
  testWidgets('PostTile menampilkan judul dan isi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: PostTile(post: _sample.first))),
    );
    expect(find.text('Judul uji'), findsOneWidget);
    expect(find.textContaining('Isi uji'), findsOneWidget);
  });

  testWidgets('PagedPostPage memuat data palsu tanpa HTTP', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postRepositoryProvider
              .overrideWithValue(FakePostRepository(items: _sample)),
        ],
        child: const MaterialApp(home: PagedPostPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Judul uji'), findsOneWidget);
    expect(find.text('Semua data termuat.'), findsOneWidget);
  });

  testWidgets('PostListPage menampilkan error + tombol Coba lagi', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postRepositoryProvider
              .overrideWithValue(FakePostRepository(throwError: true)),
        ],
        child: const MaterialApp(home: PostListPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Coba lagi'), findsOneWidget);
    expect(find.textContaining('terhubung'), findsOneWidget);
  });
}
