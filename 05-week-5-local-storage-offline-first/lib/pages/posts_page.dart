import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/network_errors.dart';
import '../data/providers.dart';

/// Data API cache-first: cache tampil seketika, refresh di background.
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsCacheProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data API'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh cache',
            onPressed: () => ref.invalidate(postsCacheProvider),
          ),
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal: $e')),
        data: (result) => Column(
          children: [
            if (result.refreshError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.orange.shade100,
                child: Text(
                  friendlyErrorMessage(result.refreshError!),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: result.cached.isEmpty
                  ? const Center(child: Text('Cache kosong.'))
                  : ListView.builder(
                      itemCount: result.cached.length,
                      itemBuilder: (context, index) {
                        final post = result.cached[index];
                        return ListTile(
                          leading: CircleAvatar(
                              child: Text(post.id.toString())),
                          title: Text(post.title),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
