# AI Challenge — PushService (Week 6)

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Prompt yang dipakai

```text
Aplikasi Flutter Campus Notification App.
Stack: firebase_messaging, flutter_local_notifications,
flutter_secure_storage, go_router, Riverpod.
Buatkan PushService dengan:
- requestPermission + getToken + onTokenRefresh (kirim ke POST /devices)
- onMessage (tampilkan local notification manual)
- onMessageOpenedApp + getInitialMessage (navigasi ke data.route)
- subscribe/unsubscribe topic pengumuman-kampus
- background handler top-level dengan @pragma('vm:entry-point')
Tandai bagian yang BERBEDA untuk Android 13+ vs iOS,
dan bagian yang tidak boleh mengakses BuildContext.
```

## Keputusan desain saya

- Kontrak `PushService` + dua implementasi: `FirebasePushService`
  (perangkat asli) dan `FakePushService` (web/demo/test deterministik).
- Parsing route terpusat di fungsi murni `routeFromMessage` agar bisa
  diunit-test tanpa Firebase.
- Token penuh tidak pernah tampil: `tokenPreview()` 12 karakter + `...`.
- `onTokenRefresh` wajib meneruskan ke backend (`POST /devices`),
  bukan sekadar log.
- Retry Dio dibatasi sekali via flag `__retried`; refresh mati →
  `clear()` + logout paksa.

## Perbaikan dari telaah saya

1. **Background handler jadi fungsi top-level** + pragma — tanpa
   BuildContext/Riverpod di dalamnya.
2. **`onTokenRefresh` hanya di-log → wajib kirim backend.**
3. **Token penuh tampil di debug → diganti preview.**
4. **Versi `flutter_local_notifications` disesuaikan** dengan API
   yang ada (inisialisasi + `show` + payload).
5. **Firebase dibuat opsional (guarded init)** agar demo web dan test
   jalan tanpa `google-services.json`.
6. **Perbedaan Android 13+ vs iOS** didokumentasikan di komentar
   (`FirebasePushService.listenForeground`).
7. **Router dibuat ulang tiap rebuild → login mengulang terus.**
   Ditemukan saat screenshot error tak kunjung tampil: `GoRouter`
   yang dibangun di dalam `build` me-remount halaman setiap state
   auth berubah. Diperbaiki dengan cache router di State (dibuat
   ulang hanya saat status login berubah).

## Tabel tiga app state (bukti deterministik via Fake)

| State | Yang diharapkan | Cara uji (demo) |
| --- | --- | --- |
| Foreground | Banner in-app muncul, klik masuk `/pengumuman/3` | `?demo=banner&banner=1`, klik banner |
| Background | Banner sistem + klik ke rute benar | Handler `onMessageOpenedApp` → `routeFromMessage` (unit-test) |
| Terminated | Buka ke rute benar via `getInitialMessage` | `handleTerminated` + `routeFromMessage` (unit-test) |

## Hasil verifikasi

```text
flutter analyze  → No issues found!
flutter test     → All tests passed! (9 unit + 3 widget)
```

Bukti screenshot: `../screenshots/` (login, error, home, banner,
pengumuman, token+topik, izin).
