# AI Challenge — Pilihan Storage (Week 5)

Nama: Aryan Zuda F (NIM 244107020060, Kelas TI-3D)

## Prompt yang dipakai

```text
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.
```

## Tabel perbandingan final saya

| Kebutuhan | SharedPreferences | Hive | sqflite | Drift | Pilihan |
| --- | --- | --- | --- | --- | --- |
| Tema + terakhir dibuka (key-value) | Pas: boolean/string langsung | Bisa, berlebihan | Bisa, berlebihan | Bisa, sangat berlebihan | **SharedPreferences** |
| CRUD 1000+ catatan + urut `updated_at` | Rapuh: satu JSON raksasa, tanpa query | Bisa: box + filter manual | Pas: `ORDER BY`, `WHERE dirty=1` | Pas tapi boilerplate besar (codegen) | **sqflite** |
| Antrean sync (dirty flag) | Tidak ada | Manual | Kolom `dirty` + query | Kolom + stream | **sqflite** |
| Reaktivitas | Tidak | ValueListenable | Manual invalidate | Stream otomatis | Riverpod + invalidate (cukup) |
| Kemudahan testing | Mock mudah | Mock mudah | Injeksi `openDb` + fake | In-memory OK | Keduanya mudah |

## Keputusan final

- **Preferensi → SharedPreferences**: hanya boolean/string, mock
  `setMockInitialValues` membuat test gampang.
- **Catatan → sqflite**: butuh query (`ORDER BY updated_at DESC`,
  `COUNT WHERE dirty=1`) yang rapuh bila dipaksakan ke key-value/Hive
  manual, sementara Drift berlebihan untuk 1 tabel (codegen + migrasi).

## Yang saya tolak/perbaiki dari rekomendasi AI

1. **Daftar catatan di SharedPreferences — ditolak.** Koleksi sebagai
   satu string JSON membuat update parsial dan sync rapuh dan lambat.
2. **Skema hanya CRUD polos — ditambah** kolom `dirty` +
   `updated_at` + tabel `cached_posts` untuk antrean sync dan cache-first.
3. **Klaim "real-time"** — reaktivitas dipenuhi Riverpod
   (`invalidate` setelah mutasi), bukan stream database.
4. **Aturan konflik eksplisit**: last-write-wins via `updated_at`.

## Hasil verifikasi

```text
flutter analyze  → No issues found!
flutter test     → All tests passed! (9 test: 7 unit + 2 widget)
```

Bukti screenshot: `../screenshots/` (daftar, badge, tambah, sync,
offline, pengaturan, detail, data API).
