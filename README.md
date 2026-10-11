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
| 01 | Mobile Development Ecosystem & Flutter Refresh | Selesai | [`W1/`](W1) |
| 02 | Declarative UI & Responsive Design | Selesai | [`W2/`](W2) |
| 03 | Navigation & State Management (Riverpod) | Belum mulai | — |
| 04 | Networking & REST API | Belum mulai | — |
| 05 | Local Storage & Offline-First | Belum mulai | — |
| 06 | Authentication, Security & FCM | Belum mulai | — |
| 07 | Clean Architecture | Belum mulai | — |
| 08 | Mid Project Review & Code Review | Belum mulai | — |
| 09 | AI-assisted Development / Vibe Coding | Belum mulai | — |
| 10 | AI Feature Integration | Belum mulai | — |
| 11 | Performance Optimization | Belum mulai | — |
| 12 | Testing & Quality Assurance | Belum mulai | — |
| 13 | CI/CD & Automation | Belum mulai | — |
| 14 | Deployment & Monitoring | Belum mulai | — |
| 15 | Secure Mobile Development | Belum mulai | — |
| 16 | Final Project Expo | Belum mulai | — |

## Minggu yang Sudah Selesai

### Minggu 1 — Ekosistem Mobile & Flutter Refresh

- Latihan mandiri Dart: fungsi `hitungLuasPersegiPanjang` dan class `Profil` dengan null safety tanpa operator `!`.
- Aplikasi kartu profil mahasiswa (Aryan Zuda F, NIM 244107020060, TI-3D) dengan `flutter doctor`/`devices` untuk target Chrome.
- Catatan: perbedaan hot reload dan hot restart + refleksi.

Detail: [`W1/README.md`](W1/README.md)

### Minggu 2 — Declarative UI & Responsive Design

- Halaman Academic Overview: header profil (Aryan Zuda F, NIM 244107020060, TI-3D) dan enam kartu informasi (IPK, SKS, Kehadiran, Status, Tugas, Beban SKS).
- Layout responsif: satu kolom di layar sempit, dua kolom di layar lebar (breakpoint 700).
- Light/dark theme lewat `CupertinoSwitch`, dilengkapi label `Semantics`.
- Widget test untuk tampilan responsif (4 test lolos).

Detail: [`W2/README.md`](W2/README.md)

## Cara Menjalankan

1. Cek kesiapan environment:

```
flutter doctor
```

2. Masuk ke direktori proyek minggu yang dituju (contoh minggu 1):

```
cd W1/my_first_app
```

3. Pasang dependensi lalu jalankan:

```
flutter pub get
flutter run -d chrome
```

Referensi:

- Modul Praktikum: Codelabs Pemrograman Mobile JTI Polinema ([https://jti-polinema.github.io/flutter-codelab/](https://jti-polinema.github.io/flutter-codelab/))
- Dokumentasi Flutter ([https://docs.flutter.dev/](https://docs.flutter.dev/)) · Panduan Dart ([https://dart.dev/guides](https://dart.dev/guides)) · Riverpod ([https://riverpod.dev/docs](https://riverpod.dev/docs))
