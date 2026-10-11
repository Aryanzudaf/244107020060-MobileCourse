import 'package:dio/dio.dart';

import 'local/note.dart';
import 'models/post.dart';
import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';

/// Contoh isi cache untuk demo cache-first (`?demo=seedposts`).
const demoCachedPosts = [
  Post(id: 1, title: 'Cache: Belajar Dio terpusat'),
  Post(id: 2, title: 'Cache: Repository pattern'),
  Post(id: 3, title: 'Cache: Pagination 10 per halaman'),
];

/// Repository yang selalu gagal (demo refresh gagal + cache tetap tampil).
class ThrowingPostRepository extends PostRepository {
  ThrowingPostRepository() : super(Dio());

  @override
  Future<List<Post>> fetchPosts() async {
    throw DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
  }
}
/// `?demo=seed` (2 dirty), `?demo=clean` (0 dirty).
class SeedNoteRepository extends NoteRepository {
  SeedNoteRepository({this.dirty = true}) : super(openDb: _noDb);

  final bool dirty;

  static Future<Never> _noDb() => throw UnimplementedError();

  static const _now = '2026-10-11T10:00:00.000';

  @override
  Future<List<Note>> fetchNotes() async => [
        Note(
          id: 1,
          title: 'Belanja mingguan',
          body: 'Susu, telur, roti.',
          updatedAt: DateTime.parse(_now),
          dirty: dirty,
        ),
        Note(
          id: 2,
          title: 'Revisi laporan',
          body: 'Bab 3 + lampiran.',
          updatedAt: DateTime.parse('2026-10-10T10:00:00.000'),
          dirty: dirty,
        ),
      ];

  @override
  Future<Note?> fetchNote(int id) async {
    final notes = await fetchNotes();
    for (final n in notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  @override
  Future<int> countDirty() async => dirty ? 2 : 0;

  @override
  Future<void> markAllSynced() async {}
}
