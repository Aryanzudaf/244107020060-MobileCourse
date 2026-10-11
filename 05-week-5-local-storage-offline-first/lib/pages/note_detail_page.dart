import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';

/// Detail catatan (`/note/:id`) dibaca dari repository lokal,
/// bukan dari state halaman list.
class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Catatan $id')),
      body: noteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal: $e')),
        data: (note) {
          if (note == null) {
            return const Center(child: Text('Catatan tidak ditemukan.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(note.body),
                const SizedBox(height: 16),
                Text(
                  note.dirty ? 'Status: belum tersinkron.' : 'Status: tersinkron.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Kembali ke daftar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
