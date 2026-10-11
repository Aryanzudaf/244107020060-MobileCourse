import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../local/note.dart';

/// Satu-satunya pintu ke tabel `notes`. Constructor menerima `openDb`
/// agar test bisa menyuntikkan pembuka palsu tanpa SQLite sungguhan.
class NoteRepository {
  NoteRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<Note?> fetchNote(int id) async {
    final db = await _openDb();
    final rows = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Note.fromMap(rows.first);
  }

  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final now = DateTime.now();
    final id = await db.insert('notes', {
      'title': title,
      'body': body,
      'updated_at': now.toIso8601String(),
      'dirty': 1,
    });
    return Note(id: id, title: title, body: body, updatedAt: now, dirty: true);
  }

  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db
        .rawQuery('SELECT COUNT(*) AS c FROM notes WHERE dirty = 1');
    return ((rows.first['c'] as num?)?.toInt() ?? 0);
  }

  /// Dipanggil hanya setelah "server" menjawab sukses.
  Future<void> markAllSynced() async {
    final db = await _openDb();
    await db.update('notes', {'dirty': 0}, where: 'dirty = 1');
  }
}
