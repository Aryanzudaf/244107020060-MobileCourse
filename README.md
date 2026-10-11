# Pemrograman Mobile — JTI Polinema

Dokumentasi praktikum mingguan mata kuliah Pemrograman Mobile, Jurusan Teknologi Informasi, Politeknik Negeri Malang. Semua proyek dikerjakan dengan Flutter SDK dan bahasa Dart.

## Identitas

| | |
| --- | --- |
| Nama | Aryan Zuda F |
| NIM | 244107020060 |
| Kelas | TI-3D |
| Program Studi | Teknik Informatika |
| Jurusan | Teknologi Informasi |
| Institusi | Politeknik Negeri Malang |

## Progres Modul

| Minggu | Topik | Status | Direktori |
| --- | --- | --- | --- |
| 01 | Mobile Development Ecosystem & Flutter Refresh | Selesai | [`01-...`](01-week-1-mobile-development-ecosystem-flutter-refresh) |
| 02 | Declarative UI & Responsive Design | Selesai | [`02-...`](02-week-2-declarative-ui-responsive-design) |
| 03 | Navigation & State Management (Riverpod) | Selesai | [`03-...`](03-week-3-navigation-state-management) |
| 04 | Networking & REST API | Belum mulai | [`04-...`](04-week-4-networking-rest-api) |
| 05 | Local Storage & Offline-First | Belum mulai | [`05-...`](05-week-5-local-storage-offline-first) |
| 06 | Authentication, Security & FCM | Belum mulai | [`06-...`](06-week-6-authentication-security-fcm) |
| 07 | Clean Architecture | Belum mulai | [`07-...`](07-week-7-clean-architecture) |
| 08 | Mid Project Review & Code Review | Belum mulai | [`08-...`](08-week-8-mid-project-review) |
| 09 | AI-assisted Development / Vibe Coding | Belum mulai | [`09-...`](09-week-9-ai-assisted-development) |
| 10 | AI Feature Integration | Belum mulai | [`10-...`](10-week-10-ai-feature-integration) |
| 11 | Performance Optimization | Belum mulai | [`11-...`](11-week-11-performance-optimization) |
| 12 | Testing & Quality Assurance | Belum mulai | [`12-...`](12-week-12-testing-quality-assurance) |
| 13 | CI/CD & Automation | Belum mulai | [`13-...`](13-week-13-ci-cd-automation) |
| 14 | Deployment & Monitoring | Belum mulai | [`14-...`](14-week-14-deployment-monitoring) |
| 15 | Secure Mobile Development | Belum mulai | [`15-...`](15-week-15-secure-mobile-development) |
| 16 | Final Project Expo | Belum mulai | [`16-...`](16-week-16-final-project-expo) |

## Minggu yang Sudah Selesai

### Minggu 1 — Ekosistem Mobile & Flutter Refresh

- Latihan mandiri Dart: fungsi `hitungLuasPersegiPanjang` dan class `Profil` dengan null safety tanpa operator `!`.
- Aplikasi kartu profil mahasiswa (Aryan Zuda F, NIM 244107020060, TI-3D) dengan `flutter doctor`/`devices` untuk target Chrome.
- Catatan: perbedaan hot reload dan hot restart + refleksi.

Detail: [`01-.../README.md`](01-week-1-mobile-development-ecosystem-flutter-refresh/README.md)

### Minggu 2 — Declarative UI & Responsive Design

- Halaman Academic Overview: header profil (Aryan Zuda F, NIM 244107020060, TI-3D) dan enam kartu informasi (IPK, SKS, Kehadiran, Status, Tugas, Beban SKS).
- Layout responsif: satu kolom di layar sempit, dua kolom di layar lebar (breakpoint 700).
- Light/dark theme lewat `CupertinoSwitch`, dilengkapi label `Semantics`.
- Widget test untuk tampilan responsif (4 test lolos).

Detail: [`02-.../README.md`](02-week-2-declarative-ui-responsive-design/README.md)

### Minggu 3 — Navigation & State Management

- Navigasi multi-halaman dengan GoRouter: `/`, `/produk`, `/stats`, dan rute detail dengan path parameter.
- State management Riverpod: `Notifier` untuk daftar tugas, provider turunan untuk filter (Semua, Aktif, Selesai).
- Penanganan `AsyncValue` untuk kondisi loading, error (tombol Coba lagi), success, dan empty.
- Tujuh test lulus dan `flutter analyze` bersih.

Detail: [`03-.../README.md`](03-week-3-navigation-state-management/README.md)

## Cara Menjalankan

1. Cek kesiapan environment:

```
flutter doctor
```

2. Masuk ke direktori proyek minggu yang dituju (contoh minggu 1):

```
cd 01-week-1-mobile-development-ecosystem-flutter-refresh/my_first_app
```

3. Pasang dependensi lalu jalankan:

```
flutter pub get
flutter run -d chrome
```

Referensi:

- Modul Praktikum: Codelabs Pemrograman Mobile JTI Polinema ([https://jti-polinema.github.io/flutter-codelab/](https://jti-polinema.github.io/flutter-codelab/))
- Dokumentasi Flutter ([https://docs.flutter.dev/](https://docs.flutter.dev/)) · Panduan Dart ([https://dart.dev/guides](https://dart.dev/guides)) · Riverpod ([https://riverpod.dev/docs](https://riverpod.dev/docs))
