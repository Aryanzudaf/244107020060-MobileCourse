# AI Challenge — Clean Architecture Feature-First (Week 7)

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

Refactor proyek Minggu 6 (`campus_notify`) menjadi Clean Architecture
feature-first. Snapshot sebelum refactor = commit Minggu 6
(`39ddcf3 feat: minggu 6 autentikasi aman + FCM ...`) — bisa
dibandingkan dan di-rollback.

## Prompt yang dipakai

```text
Project Flutter saya: campus_notify (auth + FCM + daftar pengumuman).
Kondisi kini: folder lib/{data, providers, pages, messaging},
repository tercampur dengan implementasi, widget memanggil Dio langsung.
Tugas:
1. Usulkan struktur feature-first Clean Architecture
   (presentation/domain/data) untuk fitur auth + announcements.
2. Untuk tiap file lama, sebutkan tujuan barunya (pindah/pecah/hapus).
3. Tandai bagian yang over-engineering bila diterapkan ke CRUD sederhana,
   dan kapan use case benar-benar dibutuhkan vs repository langsung.
4. Tunjukkan wiring DI dengan Riverpod (tanpa package DI tambahan).
Jelaskan trade-off setiap keputusan.
```

## Output awal AI (ringkas)

Struktur yang diusulkan AI:

```text
lib/
├── core/{failures.dart, format.dart}
├── features/auth/{domain,data,presentation}
├── features/announcements/{domain,data,presentation}
├── features/push/{domain,data,presentation}
└── main.dart            # composition root + GoRouter
```

Dengan ketentuan: interface repository di `domain`, implementasi di
`data`, mapping hanya di model, wiring DI di
`presentation/providers/*_providers.dart`, entity bebas Flutter.

## Tabel usulan AI vs keputusan final saya

| # | Usulan AI | Keputusan final saya | Alasan / trade-off |
| --- | --- | --- | --- |
| 1 | Use case untuk semua operasi (login, logout, refresh, get pengumuman) | **Sebagian ditolak**: hanya `Login` + `GetAnnouncement` yang jadi use case; logout & refresh token dipanggil repository langsung dari notifier/interceptor | Ikut aturan codelab: CRUD/satu-baris cukup repository → notifier. Use case wajib hanya saat ada aturan bisnis (validasi kredensial, id kosong). Use case per operasi = over-engineering untuk tim kecil. |
| 2 | Buat `AnnouncementModel` (`toMap/fromMap`) di data | **Ditolak sementara** | Sumber data masih statis dalam memori — tidak ada JSON/SQLite yang di-mapping. Model baru dibuat HANYA saat data pindah ke API/DB; entity + kontrak tidak akan berubah. Membuat mapping mati = kode tanpa nilai. |
| 3 | `Failure` generik (`Network`/`Local`) | **Diperluas**: + `AuthFailure` + `NotFoundFailure` (sealed) | UI perlu membedakan "kredensial ditolak" vs "data tidak ada" vs "jaringan". Sealed class tetap exhaustif di `switch`. |
| 4 | Beranda (push) mengimpor provider fitur auth untuk tombol logout | **Ditolak**: `onLogout` disuntikkan dari composition root (`main.dart`) | Cross-feature import membuat fitur push tidak bisa dilepas/diuji sendiri. Biaya: satu parameter tambahan di `HomePage`. |
| 5 | Presentation mengecek `if (svc is FakePushService)` (seperti kode lama) | **Ditolak**: `set onBanner` diangkat ke kontrak `PushService` | Presentation tidak boleh tahu tipe data. Kedua implementasi (Firebase/Fake) meneruskan (judul, isi, route) lewat kontrak yang sama. |
| 6 | Banner selalu deep link ke `/pengumuman/3` (hard-code) | **Diperbaiki**: tujuan disimpan di `PushUiState.bannerRoute` dari payload | Rute kini datang dari `data.route` notifikasi — kalau backend kirim pengumuman lain, tujuan ikut benar. |
| 7 | `apiErrorMessage` dipindah ke `core/` agar bisa dipakai UI | **Ditolak**: `core` wajib bebas import Dio (grep #2) | UI kini menerima `Failure.message` (murni). `apiErrorMessage`/`apiFailure` tetap di data sebagai batas konversi exception → Failure. |
| 8 | Interface & implementasi repository diletakkan satu folder | **Ditolak**: interface (`AuthRepository`, `SessionStore`, `AnnouncementRepository`, `PushService`) di `domain`, implementasi di `data` | Aturan emas codelab: keduanya terpisah. Test domain memakai fake yang mengimplementasi interface yang sama. |
| 9 | Pindahkan pembangunan `GoRouter` ke `routes.dart` | **Diterima sebagian**: tetap di `main.dart` (composition root) | Router butuh widget dari 3 fitur — itu peran composition root, bukan konfigurasi rute polos. Tidak memengaruhi dependency rule; mengurangi risiko perubahan perilaku. |
| 10 | `TokenStore` (kelas konkret) dipakai lintas layer | **Dipisah**: kontrak `SessionStore` (domain) + `SecureSessionStore`/`MemorySessionStore` (data) | Presentation tidak lagi mengimpor `flutter_secure_storage`. Backend indek `TokenBackend` dihapus — dua implementasi langsung mengimplementasi kontrak (satu lapisan lebih sedikit). |
| 11 | (temuan sendiri saat verifikasi browser — bukan usulan AI) Retry default Riverpod 3 untuk provider yang melempar | **Dimatikan**: `retry: (_, _) => null` di `announcementProvider` | `FutureProvider` yang `throw Failure` di-retry otomatis hingga 10x (backoff 200 ms→6,4 dtk): halaman `/pengumuman/99` terjebak spinner ±40 dtk sebelum `AsyncError` tampil. Failure di sini deterministik (id tak dikenal pasti gagal) → retry murni menunda. Untuk sumber transient (jaringan) retry default tetap berlaku. Gejala awal: spinner abadi di screenshot; diagnosis via `ProviderObserver` sementara (`start→done→dispose` berulang, `mut=null`). |
| 12 | (temuan sendiri) Screenshot deep link butuh boot langsung ke `/pengumuman/99` | **Hook demo**: `&route=` opsional pada `?banner=1` (default `/pengumuman/3`) | `GoRouter(initialLocation: home)` menimpa deep link browser saat boot (perilaku identik Minggu 6 — bukan bug). Navigasi in-app tetap satu-satunya jalan; hook ini hanya memilih payload banner untuk screenshot. Pola sama seperti `?autofail=1` yang sudah ada. |

## Pemetaan file lama → layer baru

| File lama (Minggu 6) | Layer sesudah refactor | Yang berubah |
| --- | --- | --- |
| `data/auth_repository.dart` (entity+kontrak+impl campur) | domain: `entities/auth_session.dart`, `repositories/auth_repository.dart` + data: `auth_repository_mock.dart` | Kontrak record `({session, failure})`; validasi pindah ke use case |
| `data/token_store.dart` | domain: `repositories/session_store.dart` + data: `session_store_impl.dart` | Kontrak vs implementasi (secure/memori) terpisah |
| `data/api_client.dart` | data: `features/auth/data/api_client.dart` | Konsumsi `AuthRepository` lewat record, bukan try/catch exception |
| `data/api_errors.dart` | data: `features/auth/data/api_errors.dart` | Tambah `apiFailure()` → `NetworkFailure` |
| `providers/auth_provider.dart` | presentation: `features/auth/presentation/providers/auth_providers.dart` | DI wiring + `AuthNotifier` memakai use case `Login` |
| `messaging/push_service.dart` (kontrak+2 impl+state campur) | domain: `push/domain/repositories/push_service.dart` + data: `fake_push_service.dart`, `firebase_push_service.dart` + presentation: `push_providers.dart` | `PushUiState` turun ke presentation; handler background tetap top-level di data |
| `pages/login_page.dart` | presentation: `features/auth/presentation/pages/login_page.dart` | Tampil `Failure.message` via `errorMessage()`, bukan `apiErrorMessage` (Dio) |
| `pages/home_page.dart` | presentation: `features/push/presentation/pages/home_page.dart` | Logout via callback; banner memakai `bannerRoute` |
| `pages/announcement_page.dart` (konten statis di widget) | domain: `entities/announcement.dart`, `usecases/get_announcement.dart` + data: `announcement_repository_impl.dart` + presentation: `announcements_providers.dart` + `announcement_page.dart` | Widget baca `FutureProvider`,4 state (loading/error+retry/data) |
| `routes.dart` | tetap `lib/routes.dart` | Tanpa perubahan |

## Hasil verifikasi dependency rule (tiga grep)

```text
# 1. Presentation steril dari data mentah (wajib NOL hasil)
rg "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences\.getInstance|jsonDecode" lib/features/*/presentation
→ tidak ada hasil ✅

# 2. Domain & core steril dari framework/package (wajib NOL hasil)
rg "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase" lib/features/*/domain lib/core
→ tidak ada hasil ✅

# 3. Static analysis + test
flutter analyze  → No issues found!
flutter test     → 00:03 +21: All tests passed! ✅
```

Catatan jujur untuk grep #1: `presentation/providers/auth_providers.dart`
masih meng-import `package:dio/dio.dart` **hanya untuk tipe** `Dio` pada
`apiClientProvider` (file wiring DI yang memang tempat wiring menurut
codelab). Instansiasi `Dio(BaseOptions(...))` tetap di data
(`api_client.dart`) dan tidak ada pemanggilan Dio dari halaman.

## Perbaikan dari telaah saya

1. **Kontrak & implementasi tercampur** (seminggu sebelumnya sudah
   disadari di README Minggu 6) → kini interface di `domain`, impl di
   `data`.
2. **Exception mentah bocor ke UI** (`throw Exception(...)` dari
   repository) → record `Failure` di batas data; UI hanya menerima
   `message`.
3. **Validasi kredensial di dalam repository mock** → pindah ke use
   case `Login` (aturan bisnis, diuji tanpa backend).
4. **Konten pengumuman hard-coded di widget** → jadi repository + use
   case; halaman hanya memuat state (4 state `AsyncValue`).
5. **Presentation mengecek tipe `FakePushService`** → kontrak
   `set onBanner`.
6. **Tujuan banner hard-code** → `bannerRoute` dari payload notifikasi.
7. **`tokenPreview`/`routeFromMessage` terkunci di satu fitur** →
   `core/format.dart` (dipakai lintas fitur, fungsi murni, diuji tanpa
   widget).
8. **Retry otomatis Riverpod 3 menelan error state** → `retry:
   (_, _) => null` untuk failure deterministik + test regresi widget.

## Hasil pengujian akhir

```text
Analyzing campus_notify...
No issues found!

00:03 +21: All tests passed!
```

Rincian test (21): core format (3), data auth + interceptor (6), use
case Login (3), use case GetAnnouncement (3), FakePushService (2),
widget (4 — login error, beranda, banner deep link, regresi anti-retry).

Bukti screenshot: `../screenshots/` (before/after tiap fitur +
halaman error pengumuman).
