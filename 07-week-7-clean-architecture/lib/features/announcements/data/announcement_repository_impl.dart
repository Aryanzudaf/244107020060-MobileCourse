import '../../../core/failures.dart';
import '../domain/entities/announcement.dart';
import '../domain/repositories/announcement_repository.dart';

/// Implementasi data: sumber statis dalam memori.
/// Ganti dengan implementasi berbasis Dio/SQLite saat data pindah ke
/// backend — kontrak domain tidak berubah.
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  static const _items = <String, Announcement>{
    '1': Announcement(
      id: '1',
      title: 'Kuliah pengganti Senin',
      body: 'Kuliah Pemrograman Mobile TI-3D pindah ke Selasa 10.00 di '
          'Ruang B1.',
    ),
    '2': Announcement(
      id: '2',
      title: 'UTS Pemrograman Mobile',
      body: 'UTS berlangsung 24 November 2026 di Laboratorium 3, dibawa '
          'laptop masing-masing.',
    ),
    '3': Announcement(
      id: '3',
      title: 'Jadwal kuliah berubah',
      body: 'Kelas Pemrograman Mobile TI-3D pindah ke Ruang A2 jam 13.00. '
          'Halaman ini dibuka lewat deep link dari notifikasi.',
    ),
  };

  @override
  Future<({Announcement? announcement, Failure? failure})> getAnnouncement(
    String id,
  ) async {
    final item = _items[id];
    if (item == null) {
      return (
        announcement: null,
        failure: NotFoundFailure('Pengumuman $id tidak ditemukan'),
      );
    }
    return (announcement: item, failure: null);
  }
}
