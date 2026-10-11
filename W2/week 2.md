   #02 | Declarative UI & Responsive Design   

_access\_time_90 mins remaining

1.  [Selamat datang](#0)
2.  [Konsep dan teori](#1)
3.  [Demo](#2)
4.  [Praktikum: layout sederhana (warm-up)](#3)
5.  [Praktikum: dashboard responsif](#4)
6.  [Tugas dan AI design exploration](#5)
7.  [Refleksi dan referensi](#6)

[_bug\_report_ Report a mistake](https://github.com/jti-polinema/flutter-codelab/issues)

[_close_](/)[_menu_](#)

# #02 | Declarative UI & Responsive Design

_access\_time_90 mins remaining

## 1\. Selamat datang

**Terakhir diperbarui:** 27 Agustus 2026

[Bahasa Indonesia](index.html) | [English](index-en.html)

## Tujuan Pembelajaran

Setelah menyelesaikan codelab ini, mahasiswa mampu:

*   Menjelaskan prinsip declarative UI dan hubungan antara widget, konfigurasi, serta state.
*   Menggunakan `StatelessWidget`, `StatefulWidget`, `Container`, `Row`, `Column`, dan `Expanded`.
*   Membedakan komponen Material 3 dan Cupertino untuk kebutuhan platform yang berbeda.
*   Membangun layout responsif untuk ukuran layar mobile dan tablet.
*   Menerapkan theme, dark mode, styling, dan aksesibilitas dasar.

## 2\. Konsep dan teori

## Declarative UI

Pada pendekatan deklaratif, kode mendeskripsikan tampilan berdasarkan state saat ini. Ketika state berubah, Flutter membangun ulang bagian UI yang relevan. Developer berfokus pada hubungan data dan tampilan, bukan mengubah setiap elemen UI secara manual.

```
Widget build(BuildContext context) {
  return Text('Halo, $nama');
}
```

## Widget dasar

*   `StatelessWidget` cocok untuk UI yang output-nya ditentukan oleh konfigurasi dari parent.
*   `StatefulWidget` memiliki objek `State` untuk data yang dapat berubah selama lifecycle.
*   `Container` menggabungkan ukuran, padding, margin, decoration, dan child.
*   `Row` menyusun child secara horizontal, sedangkan `Column` secara vertikal.
*   `Expanded` membagi ruang yang tersedia di dalam `Row` atau `Column`.

## Material 3 dan Cupertino

`MaterialApp` dan widget Material 3 cocok untuk pola desain Android dan lintas platform. `CupertinoApp` serta widget Cupertino menyediakan tampilan yang mengikuti pola iOS. Pilih komponen berdasarkan kebutuhan pengalaman pengguna, bukan sekadar nama platform.

## Responsive layout

Layout responsif menyesuaikan struktur UI dengan ruang yang tersedia. Gunakan `LayoutBuilder` atau `MediaQuery` untuk membaca ukuran, lalu ubah jumlah kolom atau arah layout. Hindari ukuran piksel tetap untuk elemen yang harus beradaptasi.

## Theme, dark mode, dan accessibility

Theme menyimpan warna, tipografi, dan bentuk komponen secara terpusat. Sediakan `theme` dan `darkTheme` pada `MaterialApp`. Untuk aksesibilitas, gunakan kontras yang cukup, label yang bermakna, ukuran teks yang terbaca, dan jangan menyampaikan informasi hanya melalui warna.

## 3\. Demo

## Hasil akhir yang akan dibangun

Sebelum mulai, amati target codelab ini: dashboard mahasiswa yang menampilkan **satu kolom** pada layar sempit dan **dua kolom** pada layar lebar, dengan tema terang dan gelap yang konsisten.

1.  Jalankan aplikasi hasil akhir pada emulator ukuran ponsel (misal 5"), lalu tablet (misal 10"); bandingkan jumlah kolomnya.
2.  Aktifkan dark mode pada emulator/perangkat dan amati perubahan tema secara otomatis.
3.  Perhatikan pola declarative: UI tidak diubah satu per satu, hanya state yang diperbarui dan Flutter membangun ulang tampilan.

## 4\. Praktikum: layout sederhana (warm-up)

Sebelum dashboard responsif, latih dulu widget dasar dengan membuat kartu profil sederhana. Buat project baru atau ganti sementara isi `lib/main.dart`:

```
import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: ProfileCard()),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Nama Mahasiswa',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('...ketik nama Anda di sini...'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(children: [
            Expanded(child: Text('NIM')),
            Text('...ketik NIM Anda di sini...'),
          ]),
          const Row(children: [
            Expanded(child: Text('Kelas')),
            Text('...ketik kelas Anda di sini...'),
          ]),
        ],
      ),
    );
  }
}
```

## Eksperimen warm-up

1.  Hapus `Expanded` pada baris nama, lalu amati peringatan overflow atau perilaku layout-nya; kembalikan setelah itu.
2.  Ganti `mainAxisSize: MainAxisSize.min` menjadi nilai default dan amati perubahan tinggi kartu.
3.  Tambahkan satu baris data (misal `Email`) menggunakan pola `Row` + `Expanded` yang sama.

## 5\. Praktikum: dashboard responsif

## Menyiapkan project

```
flutter create responsive_dashboard
cd responsive_dashboard
flutter run
```

Buka `lib/main.dart`. Buat aplikasi profil sederhana berikut, lalu jalankan pada emulator atau perangkat fisik.

```
import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.indigo),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 700 ? 2 : 1;
          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.6,
            children: const [
              DashboardCard(title: 'Assignments', value: '8'),
              DashboardCard(title: 'Attendance', value: '92%'),
              DashboardCard(title: 'Portfolio', value: 'Ready'),
              DashboardCard(title: 'Current week', value: '02'),
            ],
          );
        },
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({required this.title, required this.value, super.key});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Expanded(child: Text(title)),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ]),
      ),
    );
  }
}
```

## Menambahkan interaksi: StatefulWidget dan Cupertino

Sejauh ini dashboard masih `StatelessWidget`. Ubah `DashboardApp` menjadi `StatefulWidget` dan tambahkan `CupertinoSwitch` (widget Cupertino) pada `AppBar` untuk mengganti tema secara manual — sekaligus membedakan komponen Material dan Cupertino secara langsung:

```
class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.indigo),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}
```

Sesuaikan `DashboardPage` agar menerima state dan callback:

```
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });
  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              const SizedBox(width: 4),
              CupertinoSwitch(
                value: isDark,
                onChanged: onDarkChanged,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        // ... kode GridView sebelumnya, tidak berubah
      ),
    );
  }
}
```

## Eksperimen layout

1.  Ubah breakpoint dari `700` menjadi nilai lain dan amati perubahan jumlah kolom.
2.  Ubah `themeMode` menjadi `ThemeMode.dark`, lalu kembalikan ke `ThemeMode.system`.
3.  Uji aplikasi dengan ukuran layar emulator yang berbeda.
4.  Tambahkan `Semantics` atau label yang bermakna pada elemen yang penting bagi screen reader.

## 6\. Tugas dan AI design exploration

## Tugas utama

Kembangkan dashboard menjadi halaman **Academic Overview** dengan ketentuan:

*   Memiliki header profil dan minimal empat kartu informasi.
*   Menggunakan `Row`, `Column`, `Expanded`, dan `Container`.
*   Menampilkan satu kolom pada layar sempit dan dua kolom pada layar lebar.
*   Menyediakan light theme dan dark theme yang tetap terbaca, dengan toggle tema (misal `CupertinoSwitch` atau `Switch.adaptive`).
*   Memiliki label aksesibilitas untuk informasi atau tombol penting.
*   Menyertakan screenshot layar sempit dan lebar pada folder `screenshots/`.

## AI Prompt Challenge

Setelah implementasi mandiri selesai, gunakan AI hanya untuk membandingkan dua alternatif tata letak. Kerjakan challenge berikut:

1.  **Prompt desain.** Ajukan prompt ini (atau variasinya): "Bandingkan dua tata letak dashboard akademik untuk Flutter: versi `GridView` dan versi `LayoutBuilder` + `Column`. Jelaskan trade-off responsif dan aksesibilitasnya."
2.  **Prompt penguatan konsep.** "Jelaskan kapan penggunaan `Expanded` justru menyebabkan overflow di dalam `Row`, beri contoh kode yang gagal dan perbaikannya."
3.  **Verification prompt.** Minta AI mengaudit hasilnya sendiri: "Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"
4.  **Dokumentasikan.** Simpan prompt, output penting, keputusan yang dipilih, alasan teknis, dan bukti verifikasi (test/screenshots) di README tugas minggu ini.

Kriteria lolos: saran AI yang Anda pakai benar-benar berjalan, responsif, tidak menurunkan aksesibilitas, dan Anda mampu menjelaskan setiap keputusannya saat code review, bukan sekadar menyalin output AI.

## Refactoring challenge

Setelah tugas utama berjalan, rapikan kode Anda:

1.  Ekstrak kartu informasi menjadi widget reusable (misal `InfoCard`) yang menerima `title` dan `value`, sehingga tidak ada duplikasi widget.
2.  Ganti warna dan ukuran yang di-hardcode dengan `Theme.of(context)` agar mengikuti tema terang/gelap secara otomatis.
3.  Pindahkan breakpoint ke satu konstanta bernama (misal `const kWideBreakpoint = 700;`) agar hanya didefinisikan satu kali.
4.  Jalankan `flutter analyze` dan pastikan tidak ada error maupun warning baru.

## Testing dasar

Tambahkan widget test di folder `test/` untuk memverifikasi perilaku responsif. Override ukuran layar menggunakan `tester.view`:

```
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Dashboard satu kolom di layar sempit', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());

    final width = tester.getSize(find.byType(Card)).width;
    expect(width, lessThan(700));
  });

  testWidgets('Dashboard dua kolom di layar lebar', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());

    final width = tester.getSize(find.byType(Card)).width;
    expect(width, greaterThan(500));
  });
}
```

Jalankan dengan `flutter test`. Kedua test harus lulus sebelum tugas dikumpulkan. Simpan hasil test pada folder `test/` di folder tugas minggu ini.

## Checklist verifikasi

*   `flutter analyze` tidak menghasilkan error.
*   `flutter test` lulus semua widget test responsif.
*   Aplikasi dapat dijalankan pada ukuran layar sempit dan lebar.
*   Dark mode memiliki kontras dan teks yang terbaca.
*   Struktur widget dapat dijelaskan saat code review.
*   Screenshot, folder `test/`, dan README sudah tersimpan pada folder tugas Week 2.

## 7\. Refleksi dan referensi

## Refleksi

*   Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?
*   Kapan `Expanded` membantu dan kapan penggunaannya justru menghasilkan layout error?
*   Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?
*   Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?

## Referensi

*   [Flutter UI documentation](https://docs.flutter.dev/ui)
*   [Building responsive apps](https://docs.flutter.dev/ui/layout/responsive)
*   [Material Design 3](https://m3.material.io/)
*   [Flutter accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility)

[Back](# "Previous step")

[Next](# "Next step")[Done](/ "Codelab complete")