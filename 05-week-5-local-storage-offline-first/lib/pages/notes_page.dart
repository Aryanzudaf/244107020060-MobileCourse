import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../widgets/note_tile.dart';

/// Daftar catatan offline + badge dirty + tombol Sync + banner offline.
/// `?dialog=add` (web) membuka dialog tambah otomatis untuk screenshot.
class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    if (Uri.base.queryParameters['dialog'] == 'add') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_dialogShown) {
          _dialogShown = true;
          _showAddDialog();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyAsync = ref.watch(dirtyCountProvider);
    final offline = ref.watch(forceOfflineProvider);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Offline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_outlined),
            tooltip: 'Data API',
            onPressed: () => context.go('/posts'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (offline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange.shade100,
              child: const Text(
                'Mode offline: perubahan tersimpan lokal.',
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: dirtyAsync.when(
                    loading: () => const Text('Menghitung...'),
                    error: (e, _) => Text('Gagal: $e'),
                    data: (count) => Text(
                      count == 0
                          ? 'Semua tersinkron.'
                          : '$count belum tersinkron.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: syncState.isLoading
                      ? null
                      : () => ref.read(syncProvider.notifier).sync(),
                  icon: const Icon(Icons.sync, size: 18),
                  label: const Text('Sync'),
                ),
              ],
            ),
          ),
          if (syncState case AsyncData(value: final n) when n > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('$n catatan tersinkron.'),
            ),
          Expanded(
            child: notesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal: $e')),
              data: (notes) {
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('Belum ada catatan.'),
                  );
                }
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteTile(
                      note: note,
                      onDelete: () async {
                        await ref
                            .read(noteRepositoryProvider)
                            .deleteNote(note.id!);
                        ref.invalidate(notesProvider);
                        ref.invalidate(dirtyCountProvider);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final title = TextEditingController();
    final body = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catatan baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Judul')),
            TextField(
                controller: body,
                decoration: const InputDecoration(labelText: 'Isi')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (title.text.trim().isNotEmpty) {
                await ref.read(noteRepositoryProvider).addNote(
                      title: title.text.trim(),
                      body: body.text.trim(),
                    );
                ref.invalidate(notesProvider);
                ref.invalidate(dirtyCountProvider);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
