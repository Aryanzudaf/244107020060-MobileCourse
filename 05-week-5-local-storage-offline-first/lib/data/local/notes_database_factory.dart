import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Inisialisasi factory SQLite untuk web (Chrome). Tanpa ini,
/// `getDatabasesPath`/`openDatabase` gagal di browser.
void initNotesDatabaseFactory() {
  databaseFactory = databaseFactoryFfiWeb;
}
