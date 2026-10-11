import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/post.dart';
import '../data/providers.dart';

/// Halaman detail (`/post/:id`): judul + isi + komentar.
/// `initial` diisi saat dibuka dari daftar; diambil ulang saat deep link.
class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key, required this.id, this.initial});

  final int id;
  final Post? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync =
        ref.watch(postDetailProvider((id: id, initial: initial)));
    final commentsAsync = ref.watch(commentsProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Post $id')),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userMessage(err)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(
                  postDetailProvider((id: id, initial: initial)),
                ),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (post) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(post.body),
            const Divider(height: 32),
            Text('Komentar',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            commentsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text(userMessage(err)),
              data: (comments) => Column(
                children: [
                  for (final c in comments)
                    ListTile(
                      leading: CircleAvatar(child: Text(c.id.toString())),
                      title: Text(c.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${c.email}\n${c.body}'),
                      isThreeLine: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
