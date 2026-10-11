# AI Challenge — Comment Repository (Week 4)

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Prompt yang dipakai

```text
Buatkan repository layer Flutter untuk endpoint GET /comments?postId={id}
dari JSONPlaceholder menggunakan Dio + flutter_riverpod.
Requirements:
- Model Comment dengan fromJson aman null (postId, id, name, email, body).
- CommentRepository dengan method fetchComments(postId) + timeout 10 detik.
- AsyncNotifierProvider dengan penanganan error otomatis (AsyncError)
  dan fungsi pesan error ramah pengguna untuk timeout, connection error,
  404, dan 500.
- Satu unit test untuk fromJson dengan field yang hilang.
Jelaskan setiap bagian kode dalam komentar.
```

## Keputusan desain saya

- `CommentRepository` diletakkan sejajar `PostRepository` di
  `lib/data/repositories/`, memakai Dio terpusat yang sama.
- Komentar diekspos lewat `commentsProvider` (family per `postId`)
  di data layer agar bisa di-unit-test tanpa UI.
- Detail post memakai `postDetailProvider` (family): dari `extra`
  bila dibuka dari daftar, fetch ulang bila deep link.

## Perbaikan dari telaah saya

1. **`fromJson` diperkuat** (`lib/data/json.dart`): helper
   `jsonInt`/`jsonStr` menoleransi angka-dalam-string (`"3"`),
   bukan hanya field hilang — ditemukan lewat edge-case test saya
   sendiri yang awalnya gagal (cast `as num?` crash untuk String).
2. **Family API Riverpod 3.4.3**: `AsyncNotifierProviderFamily`
   sebagai fungsi tidak ada; dipakai
   `AsyncNotifierProvider.family<Notifier, State, Arg>(...)`
   dengan `retry:` yang didukung builder.
3. **Tipe `Override` tidak diekspor publik** flutter_riverpod 3:
   override demo di-inline di `main.dart` (collection-if) agar tipe
   disimpulkan otomatis, bukan lewat fungsi beranotasi.
4. **Retry otomatis dimatikan** (`retry: (...) => null`) agar error
   final dan test deterministik (pola yang sama seperti Week 3).
5. Import tak terpakai dibersihkan sampai `flutter analyze` bersih.

## Hasil verifikasi

```text
flutter analyze  → No issues found!
flutter test     → All tests passed! (12 test: 9 unit + 3 widget)
```

Bukti screenshot: `../screenshots/` (paged, simple, error, empty,
detail + komentar).
