import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/data/repositories/note_repository.dart';

/// Repository palsu untuk test (tanpa SQLite sungguhan).
class FakeNoteRepository extends NoteRepository {
  FakeNoteRepository({this.items = const [], this.throwError = false})
      : super(openDb: _noDb);

  final List<Note> items;
  final bool throwError;

  static Future<Never> _noDb() => throw UnimplementedError();

  @override
  Future<List<Note>> fetchNotes() async {
    if (throwError) throw Exception('db locked (simulasi)');
    return items;
  }

  @override
  Future<int> countDirty() async {
    if (throwError) throw Exception('db locked (simulasi)');
    return items.where((n) => n.dirty).length;
  }

  @override
  Future<void> markAllSynced() async {}
}
