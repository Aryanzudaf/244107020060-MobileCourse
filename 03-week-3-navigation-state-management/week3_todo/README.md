# week3_todo — ToDo + Riverpod + GoRouter

Praktikum 2 & 3 + AI Challenge Week 3: aplikasi ToDo dengan navigasi
tab dan state management Riverpod.

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Isi

- `lib/main.dart` — `ProviderScope` + `StatefulShellRoute` 3 tab
  (`/`, `/produk`, `/stats`) dengan `NavigationBar`.
- `lib/providers/todo_provider.dart` — `TodoListNotifier` immutable
  (operasi by id) + filter Semua/Aktif/Selesai + `filteredTodosProvider`.
- `lib/providers/stats_provider.dart` — `AsyncNotifier` statistik dari
  daftar tugas asli (retry otomatis dimatikan agar error bertahan).
- `lib/providers/product_provider.dart` — `AsyncNotifier` daftar produk
  simulasi (loading → error + Coba lagi → success).
- `lib/pages/`, `lib/widgets/todo_tile.dart` — UI per tab.
- `test/` — 2 unit notifier + 1 unit stats sukses/gagal + 3 widget test.

## Jalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

7 test lulus. Query demo web: `?demo=seed` (isi contoh),
`?stats=fail` / `?produk=fail` (simulasi error), `?dialog=add`
(buka dialog tambah).
