import '../../../../core/failures.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

/// Satu operasi bisnis: ambil satu pengumuman berdasar id.
///
/// Aturan di sini: id kosong/spasi ditolak lebih dulu (tanpa menyentuh
/// repository) sehingga bisa diuji murni.
class GetAnnouncement {
  const GetAnnouncement(this._repository);

  final AnnouncementRepository _repository;

  Future<({Announcement? announcement, Failure? failure})> call(
    String id,
  ) async {
    final normalized = id.trim();
    if (normalized.isEmpty) {
      return (
        announcement: null,
        failure: const NotFoundFailure('ID pengumuman kosong'),
      );
    }
    return _repository.getAnnouncement(normalized);
  }
}
