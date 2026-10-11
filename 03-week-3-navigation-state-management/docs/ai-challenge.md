# AI Challenge — StatsPage (Week 3)

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Prompt yang dipakai

```text
Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod.
Requirements:
- ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan
  pengambilan data statistik (delay 2 detik, kadang gagal 30%).
- UI harus menangani loading (spinner), error (pesan + tombol retry),
  dan success (ListView 3 item).
- Berikan unit test untuk notifier-nya.
Jelaskan setiap bagian kode dalam komentar.
```

## Keputusan desain saya

- Statistik dihitung dari `todoListProvider` asli (total, selesai,
  sisa), bukan angka hardcoded — lewat `ref.watch` di `build()`.
- Delay 800ms dan mode gagal deterministik (`?stats=fail`) agar bisa
  diuji dan di-screenshot tanpa keacakan 30%.
- Operasi todo berbasis `id` (bukan index) agar tetap benar saat
  filter Aktif/Selesai aktif.
- `TodoTile` dan `filteredTodosProvider` dipisah (refactoring challenge).

## Perbaikan dari telaah saya

1. **Retry otomatis Riverpod 3 dimatikan** (`retry: (...) => null`).
   Tanpa ini, provider yang gagal di-retry sendiri dan state bertahan
   di `AsyncLoading` — tombol Coba lagi tidak pernah terlihat.
   Terbukti lewat test yang gagal sebelum perbaikan.
2. **`ref.watch` hanya di `build`, `ref.read` di callback** — tidak ada
   `watch` di dalam `onPressed`/`onChanged`.
3. **Tanpa API lama** — hanya `Notifier`/`AsyncNotifier` +
   `ConsumerWidget`; tanpa `StateProvider`/`StateNotifierProvider`.
4. **Tiga state eksplisit** — `loading` (spinner + label),
   `error` (pesan + Coba lagi via `ref.invalidate`),
   `data` (persentase + 3 baris) — plus empty saat tugas kosong.

## Hasil verifikasi

```text
flutter analyze  → No issues found!
flutter test     → All tests passed! (7 test: 4 unit + 3 widget)
```

Bukti screenshot: `../screenshots/` (todo, produk, statistik, error).
