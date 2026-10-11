import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'notes_database_factory.dart';

/// Satu fungsi pembuka dipakai seluruh repository lokal.
Future<Database> openNotesDb() async {
  if (kIsWeb) initNotesDatabaseFactory();
  final dir = await getDatabasesPath();
  // `path` tidak dipakai agar impor tetap minimal; gabung manual.
  return openDatabase(
    '$dir/offline_notes.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL DEFAULT '',
          updated_at TEXT NOT NULL,
          dirty INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE cached_posts(
          id INTEGER PRIMARY KEY,
          payload TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');
    },
  );
}
