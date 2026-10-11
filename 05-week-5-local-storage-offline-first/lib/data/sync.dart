import 'package:sqflite/sqflite.dart';

import 'local/db.dart';
import 'models/post.dart';
import 'network_errors.dart';
import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';

/// Penyimpanan cache `cached_posts` agar repository CRUD tetap fokus.
class PostCacheStore {
  PostCacheStore({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Post>> readCached() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts', orderBy: 'id ASC');
    return [
      for (final r in rows)
        Post(
          id: ((r['id'] as num?)?.toInt() ?? 0),
          title: r['payload'] as String? ?? '',
        ),
    ];
  }

  /// Insert berurutan (tanpa batch) agar aman di sqflite web.
  Future<void> writeCache(List<Post> posts) async {
    final db = await _openDb();
    await db.delete('cached_posts');
    for (final p in posts) {
      await db.insert('cached_posts', {
        'id': p.id,
        'payload': p.title,
        'cached_at': DateTime.now().toIso8601String(),
      });
    }
  }
}

/// Sinkronisasi catatan kotor: hitung → simulasi upload → tandai bersih.
/// Mengembalikan jumlah yang tersinkron. Aturan konflik: last-write-wins
/// berdasarkan `updated_at` (daftar selalu diurutkan terbaru dulu).
Future<int> syncNotes(
  NoteRepository repo, {
  Future<void> Function()? uploader,
}) async {
  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;
  // Simulasi upload; project nyata mengirim tiap catatan dirty ke REST API.
  await (uploader?.call() ?? Future.delayed(const Duration(seconds: 1)));
  await repo.markAllSynced();
  return dirtyCount;
}

/// Hasil cache-first: cache seketika + info refresh background.
class CachedPostsResult {
  const CachedPostsResult({required this.cached, this.refreshError});

  final List<Post> cached;
  final Object? refreshError;
}

Future<CachedPostsResult> loadPostsCacheFirst({
  required PostCacheStore cache,
  required PostRepository remote,
  bool forceOffline = false,
  List<Post> seedIfEmpty = const [],
}) async {
  var cached = await cache.readCached();
  // Demo deterministik: pakai contoh tanpa tulis DB
  // (tulis IndexedDB tidak stabil pada screenshot headless).
  if (cached.isEmpty && seedIfEmpty.isNotEmpty) {
    cached = seedIfEmpty;
  }
  if (forceOffline) {
    return CachedPostsResult(
      cached: cached,
      refreshError: const OfflineException('Mode offline: refresh dilewati.'),
    );
  }
  try {
    final fresh = await remote.fetchPosts();
    await cache.writeCache(fresh);
    return CachedPostsResult(cached: await cache.readCached());
  } catch (e) {
    return CachedPostsResult(cached: cached, refreshError: e);
  }
}
