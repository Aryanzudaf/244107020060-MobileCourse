import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'local/note.dart';
import 'network_errors.dart';
import 'prefs.dart';
import 'preview_fakes.dart';
import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';
import 'sync.dart';

// ---------- Preferensi ----------

final prefsRepositoryProvider = Provider((ref) => PrefsRepository());

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.watch(prefsRepositoryProvider).getDarkMode();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

final darkModeProvider =
    AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

final lastOpenedProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(prefsRepositoryProvider);
  await repo.markOpenedNow();
  return repo.getLastOpened();
});

// ---------- Catatan ----------

final noteRepositoryProvider = Provider((ref) => NoteRepository());

final notesProvider = FutureProvider<List<Note>>((ref) {
  return ref.watch(noteRepositoryProvider).fetchNotes();
});

final dirtyCountProvider = FutureProvider<int>((ref) async {
  // Ikut refresh setiap daftar berubah.
  ref.watch(notesProvider);
  return ref.watch(noteRepositoryProvider).countDirty();
});

/// Toggle simulasi offline deterministik (demo + testing).
class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => Uri.base.queryParameters['offline'] == '1';

  void set(bool value) => state = value;
}

final forceOfflineProvider =
    NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

class SyncNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async => 0;

  Future<void> sync() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final count = await syncNotes(ref.read(noteRepositoryProvider));
      ref.invalidate(notesProvider);
      ref.invalidate(dirtyCountProvider);
      return count;
    });
  }
}

final syncProvider =
    AsyncNotifierProvider<SyncNotifier, int>(SyncNotifier.new);

final noteDetailProvider = FutureProvider.family<Note?, int>((ref, id) {
  return ref.watch(noteRepositoryProvider).fetchNote(id);
});

// ---------- Cache-first posts ----------

final postRepositoryProvider = Provider((ref) => PostRepository(createDio()));

final postsCacheProvider = FutureProvider<CachedPostsResult>((ref) async {
  final demo = Uri.base.queryParameters['demo'];
  // Mode demo (screenshot): tanpa DB/network agar deterministik di headless.
  // Jalur asli (di bawah) tetap dipakai di perangkat.
  if (demo == 'seedposts') {
    return const CachedPostsResult(cached: demoCachedPosts);
  }
  if (demo == 'cachefail') {
    return CachedPostsResult(
      cached: demoCachedPosts,
      refreshError: const OfflineException('Simulasi refresh gagal.'),
    );
  }
  return loadPostsCacheFirst(
    cache: PostCacheStore(),
    remote: ref.watch(postRepositoryProvider),
    forceOffline: ref.watch(forceOfflineProvider),
  );
});
