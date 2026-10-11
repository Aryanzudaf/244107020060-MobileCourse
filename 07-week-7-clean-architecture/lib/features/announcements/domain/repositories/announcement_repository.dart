import '../../../../core/failures.dart';
import '../entities/announcement.dart';

/// Kontrak pembacaan pengumuman yang dibutuhkan domain.
/// Implementasi (in-memory/remote) hidup di `data`.
abstract class AnnouncementRepository {
  Future<({Announcement? announcement, Failure? failure})> getAnnouncement(
    String id,
  );
}
