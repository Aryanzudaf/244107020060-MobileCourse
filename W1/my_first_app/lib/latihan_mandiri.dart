// Latihan mandiri Minggu 1 — Aryan Zuda F (244107020060, TI-3D).
// Jalankan dari folder W1/my_first_app:
//   dart run lib/latihan_mandiri.dart
// ignore_for_file: avoid_print

void main() {
  // 1. Contoh hitung luas dengan angka berbeda dari referensi.
  const panjang = 12.5;
  const lebar = 4.2;
  final luas = hitungLuasPersegiPanjang(panjang, lebar);
  print('Panjang: $panjang, Lebar: $lebar');
  print('Luas persegi panjang = $luas');

  // Contoh kedua untuk memastikan fungsi reusable.
  print(
    'Cek ulang (7.0 x 3.0) = ${hitungLuasPersegiPanjang(7.0, 3.0)}',
  );

  // 2 & 3. Profil dengan email terisi dan kosong.
  const profilAktif = Profil(
    nama: 'Aryan Zuda F',
    nim: '244107020060',
    email: 'aryanzf1@gmail.com',
  );
  const profilKosong = Profil(
    nama: 'Aryan Zuda F',
    nim: '244107020060',
    email: '   ',
  );
  print(profilAktif.ringkasan());
  print(profilKosong.ringkasan());
}

/// Menghitung luas persegi panjang. Menolak nilai negatif agar logis.
double hitungLuasPersegiPanjang(double panjang, double lebar) {
  assert(panjang >= 0 && lebar >= 0, 'panjang/lebar tidak boleh negatif');
  return panjang * lebar;
}

/// Data profil mahasiswa. Email boleh null/kosong.
class Profil {
  const Profil({required this.nama, required this.nim, this.email});

  final String nama;
  final String nim;
  final String? email;

  /// Tanpa operator `!`: memakai `?.`, trim, dan fallback default.
  String ringkasan() {
    final bersih = email?.trim() ?? '';
    final tampil = bersih.isEmpty ? 'belum diisi' : bersih;
    return 'Nama: $nama | NIM: $nim | Email: $tampil';
  }
}
