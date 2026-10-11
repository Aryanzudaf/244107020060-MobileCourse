# week3_navigation — GoRouter

Praktikum 1 Week 3: aplikasi multi-page dengan GoRouter.

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Isi

- `/` — daftar 10 mata kuliah Semester 5 (`lib/pages/home_page.dart`).
- `/detail/:id` — detail matkul dari path parameter
  (`lib/pages/detail_page.dart`); bisa dibuka langsung (deep link).

## Jalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

2 widget test lulus (buka detail dari daftar + deep link langsung).
