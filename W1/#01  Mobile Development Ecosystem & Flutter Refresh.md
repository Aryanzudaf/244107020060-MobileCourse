 #01 | Mobile Development Ecosystem & Flutter Refresh 

_access\_time_140 mins remaining

1.  [Selamat datang](#0)
2.  [Ekosistem mobile dan Flutter](#1)
3.  [Dart refresh](#2)
4.  [Menyiapkan environment](#3)
5.  [Praktikum: aplikasi Flutter pertama](#4)
6.  [Git dan portfolio](#5)
7.  [Verifikasi, tugas, dan refleksi](#6)

[_bug\_report_ Report a mistake](https://github.com/jti-polinema/flutter-codelab/issues)

[_close_](/)[_menu_](#)

# #01 | Mobile Development Ecosystem & Flutter Refresh

_access\_time_140 mins remaining

## 1\. Selamat datang

**Terakhir diperbarui:** 23 Agustus 2026  

## Tujuan pembelajaran

Setelah menyelesaikan codelab ini, mahasiswa mampu:

*   menjelaskan evolusi pengembangan mobile serta perbedaan native, hybrid, dan cross-platform;
*   menjelaskan arsitektur Flutter, peran Dart, struktur proyek, dan widget tree;
*   mengulang dasar Dart: variabel, tipe data, fungsi, class, dan null safety;
*   menyiapkan Flutter, Android SDK, emulator atau perangkat fisik, lalu menjalankan aplikasi pertama;
*   mengubah UI awal Flutter dan menyimpan hasilnya pada repository Git pribadi.

## Persiapan

*   Laptop/PC, koneksi internet, dan akun GitHub atau GitLab.
*   Git, VS Code (ekstensi Flutter dan Dart), Flutter SDK, Android Studio, dan Android SDK.
*   Emulator Android aktif atau perangkat Android fisik dengan _USB debugging_.

## 2\. Ekosistem mobile dan Flutter

## Evolusi pengembangan mobile

Aplikasi mobile mula-mula umum dibangun secara **native**: Kotlin/Java untuk Android dan Swift/Objective-C untuk iOS. Kebutuhan merilis fitur yang sama di lebih dari satu platform mendorong pendekatan hybrid dan cross-platform.

| Pendekatan | Ciri utama | Contoh |
| --- | --- | --- |
| Native | Kode dan UI khusus setiap platform; akses API perangkat paling langsung. | Kotlin, Swift |
| Hybrid | Aplikasi web berjalan dalam pembungkus native. | Ionic, Cordova |
| Cross-platform | Satu basis kode menghasilkan aplikasi di beberapa platform. | Flutter, React Native |

Pilihan teknologi bergantung pada performa, akses fitur perangkat, keahlian tim, biaya, dan target platform. Cross-platform tidak selalu menggantikan native; keduanya memiliki trade-off.

## Arsitektur Flutter dan peran Dart

Flutter menggunakan Dart untuk UI dan logika aplikasi. Arsitekturnya terdiri dari **framework** (widget dan API), **engine** (rendering, teks, grafis), serta **embedder** yang menghubungkan aplikasi dengan Android, iOS, web, atau desktop. Dart mendukung _just-in-time_ (JIT) saat pengembangan dan _ahead-of-time_ (AOT) saat build rilis.

## Widget tree dan struktur proyek

UI Flutter bersifat deklaratif: UI menggambarkan state saat ini. Semua bagian UI adalah widget yang disusun sebagai pohon, misalnya `MaterialApp` → `Scaffold` → `Column` → `Text`.

*   `lib/`: kode aplikasi; titik awal standar adalah `lib/main.dart`.
*   `test/`: unit dan widget test.
*   `android/`, `ios/`, `web/`: konfigurasi target platform.
*   `pubspec.yaml`: metadata, dependency, aset, dan versi SDK.

## Hot reload dan hot restart

*   **Hot reload** memasukkan perubahan kode tanpa biasanya menghapus state; gunakan untuk iterasi UI.
*   **Hot restart** menjalankan ulang aplikasi dari awal sehingga state hilang; gunakan ketika perubahan tidak dapat diterapkan melalui hot reload, misalnya inisialisasi aplikasi.

## 3\. Dart refresh

## Dasar Dart yang perlu diingat

Dart adalah bahasa bertipe statis dengan inferensi tipe. Gunakan tipe eksplisit ketika membantu keterbacaan dan `final` untuk nilai yang hanya diinisialisasi sekali.

```
void main() {
  String nama = 'Alya';
  int semester = 3;
  final bool aktif = true;
  print(sapa(nama, semester));
  final mahasiswa = Mahasiswa(nama: nama, aktif: aktif);
  print(mahasiswa.status());
}

String sapa(String nama, int semester) => 'Halo $nama, semester $semester';

class Mahasiswa {
  Mahasiswa({required this.nama, required this.aktif});
  final String nama;
  final bool aktif;
  String status() => aktif ? '$nama aktif' : '$nama tidak aktif';
}
```

## Null safety

Nilai tidak boleh `null` secara default. Tambahkan `?` hanya jika nilai memang boleh kosong. Periksa sebelum memakai nilainya; jangan gunakan `!` kecuali Anda dapat membuktikan nilainya tidak null.

```
String? namaPanggilan;
print(namaPanggilan?.toUpperCase() ?? 'BELUM DIISI');
```

## Latihan mandiri

1.  Buat fungsi `hitungLuasPersegiPanjang` yang menerima panjang dan lebar bertipe `double`.
2.  Buat class `Profil` dengan properti `nama`, `nim`, dan `email` yang boleh kosong.
3.  Panggil keduanya dari `main()`, lalu tangani email kosong dengan aman.

## 4\. Menyiapkan environment

## Instalasi dan verifikasi

1.  Instal Git dari [git-scm.com](https://git-scm.com/), lalu jalankan `git --version`.
2.  Instal [VS Code](https://code.visualstudio.com/) dan ekstensi **Flutter** (Dart ikut terpasang).
3.  Instal Flutter SDK mengikuti [panduan resmi](https://docs.flutter.dev/get-started/install); tambahkan `flutter/bin` ke `PATH`.
4.  Instal Android Studio beserta Android SDK, Command-line Tools, dan emulator melalui SDK Manager serta Device Manager.
5.  Buka terminal baru dan jalankan perintah berikut.

```
flutter --version
flutter doctor
flutter doctor --android-licenses
```

Selesaikan setiap masalah yang menghambat target Android, lalu jalankan kembali `flutter doctor`.

## Target perangkat

**Emulator:** buat dan jalankan virtual device dari Android Studio Device Manager. **Perangkat fisik:** aktifkan Developer options dan USB debugging, hubungkan kabel data, lalu izinkan komputer saat diminta.

```
flutter devices
```

Perintah ini harus menampilkan minimal satu target. Jika perangkat fisik tidak muncul, cek kabel, driver USB, USB debugging, serta dialog otorisasi pada perangkat.

## 5\. Praktikum: aplikasi Flutter pertama

## Membuat dan menjalankan proyek

Buka terminal pada folder kerja, lalu jalankan:

```
flutter create my_first_app
cd my_first_app
flutter run
```

Pilih emulator atau perangkat fisik bila diminta. Setelah aplikasi contoh tampil, tekan `r` di terminal untuk hot reload atau `R` untuk hot restart.

## Mengubah UI default

Buka `lib/main.dart`, ganti isinya dengan kode berikut, simpan, dan amati hot reload.

```
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.school, size: 72),
            SizedBox(height: 16),
            Text('Nama Anda', style: TextStyle(fontSize: 24)),
            Text('Pemrograman Mobile — Minggu 1'),
          ]),
        ),
      ),
    );
  }
}
```

Ganti `Nama Anda` dengan nama sendiri. Ubah ikon atau teks sekali, lalu bandingkan hasil hot reload dan hot restart.

## 6\. Git dan portfolio

## Inisialisasi repository

Di dalam folder `my_first_app`, konfigurasikan identitas Git bila belum pernah dilakukan dan buat commit awal:

```
git config --global user.name "Nama Anda"
git config --global user.email "email@contoh.com"
git init
git add .
git commit -m "feat: create week 1 Flutter profile app"
```

Buat repository kosong di GitHub atau GitLab (tanpa README awal jika sudah ada lokal), lalu hubungkan dan unggah commit (nim ganti dengan NIM Anda):

```
git branch -M main
git remote add origin https://github.com/USERNAME/nim-mobile-course.git
git push -u origin main
```

## Struktur repository portfolio 16 minggu

Gunakan satu repository pribadi untuk mendokumentasikan progres selama satu semester. Buat folder tugas mingguan dan artefaknya sejak awal dengan struktur berikut.

```
nim-mobile-course/
├── README.md
├── 01-week-1-mobile-development-ecosystem-flutter-refresh/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 02-week-2-declarative-ui-responsive-design/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 03-week-3-navigation-state-management/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 04-week-4-networking-rest-api/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 05-week-5-local-storage-offline-first/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 06-week-6-authentication-security-fcm/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 07-week-7-clean-architecture/
│   ├── README.md
│   ├── lib/
│   ├── test/
│   └── screenshots/
├── 08-week-8-mid-project-review/
│   ├── README.md
│   ├── docs/
│   └── screenshots/
├── 09-week-9-ai-assisted-development/
│   ├── README.md
│   ├── lib/
│   ├── docs/
│   └── screenshots/
├── 10-week-10-ai-feature-integration/
│   ├── README.md
│   ├── lib/
│   ├── docs/
│   └── screenshots/
├── 11-week-11-performance-optimization/
│   ├── README.md
│   ├── lib/
│   ├── docs/
│   └── screenshots/
├── 12-week-12-testing-quality-assurance/
│   ├── README.md
│   ├── test/
│   ├── coverage/
│   └── screenshots/
├── 13-week-13-ci-cd-automation/
│   ├── README.md
│   ├── .github/
│   ├── workflows/
│   └── screenshots/
├── 14-week-14-deployment-monitoring/
│   ├── README.md
│   ├── docs/
│   └── screenshots/
├── 15-week-15-secure-mobile-development/
│   ├── README.md
│   ├── docs/
│   └── screenshots/
├── 16-week-16-final-project-expo/
│   ├── README.md
│   ├── lib/
│   ├── docs/
│   ├── screenshots/
│   └── demo-video/
├── notes/
│   ├── reflections/
│   ├── learning-journal/
│   └── resources/
└── portfolio-summary.md
```

Untuk Minggu 1, simpan aplikasi pada folder `01-week-1-mobile-development-ecosystem-flutter-refresh/`. Setiap folder tugas berisi README yang menjelaskan tujuan, fitur utama, stack teknologi, cara menjalankan, dan hasil yang dicapai. Gunakan `screenshots/` atau `docs/` sebagai bukti visual dan dokumentasi; simpan hasil test dan coverage pada folder yang sesuai.

## 7\. Verifikasi, tugas, dan refleksi

## Checklist verifikasi

*   `flutter doctor` tidak memiliki masalah yang menghambat target Android.
*   `flutter devices` mendeteksi emulator/perangkat fisik.
*   Aplikasi berjalan dan UI default telah diganti dengan profil sederhana.
*   Anda dapat menjelaskan perbedaan hot reload dan hot restart.
*   Repository remote berisi source code, README, screenshot, dan riwayat commit.

## Mini assignment

Buat aplikasi Profil Mahasiswa berdasarkan praktikum. Tambahkan NIM dan satu informasi tambahan menggunakan widget dasar. Push hasil ke repository portfolio sesuai struktur yang ditentukan. Sertakan screenshot dan penjelasan singkat atas satu kendala setup yang Anda temui.

## Refleksi

*   Kapan native lebih tepat dipilih daripada cross-platform?
*   Bagaimana perubahan state berhubungan dengan widget tree dan UI deklaratif?
*   Mengapa commit kecil dengan pesan jelas bermanfaat bagi pekerjaan tim dan portfolio?

## Referensi pendukung

*   [Flutter installation guide](https://docs.flutter.dev/get-started/install)
*   [Flutter: declarative UI](https://docs.flutter.dev/get-started/flutter-for/declarative)
*   [Official Dart language documentation](https://dart.dev/language)
*   [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)

[Back](# "Previous step")

[Next](# "Next step")[Done](/ "Codelab complete")