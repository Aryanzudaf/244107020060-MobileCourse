import 'package:campus_notify/core/failures.dart';
import 'package:campus_notify/features/announcements/domain/entities/announcement.dart';
import 'package:campus_notify/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:campus_notify/features/announcements/domain/usecases/get_announcement.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repository palsu: tanpa database/jaringan sungguhan.
class FakeAnnouncementRepository implements AnnouncementRepository {
  FakeAnnouncementRepository({this.item, this.fail = false});

  final Announcement? item;
  final bool fail;

  @override
  Future<({Announcement? announcement, Failure? failure})> getAnnouncement(
    String id,
  ) async {
    if (fail) {
      return (
        announcement: null,
        failure: const LocalFailure('db locked (simulasi)'),
      );
    }
    return (announcement: item, failure: null);
  }
}

void main() {
  const sample = Announcement(
    id: '3',
    title: 'Jadwal kuliah berubah',
    body: 'Pindah ke Ruang A2.',
  );

  test('GetAnnouncement meneruskan pengumuman dari repository', () async {
    final repo = FakeAnnouncementRepository(item: sample);
    final result = await GetAnnouncement(repo)('3');
    expect(result.failure, isNull);
    expect(result.announcement!.title, 'Jadwal kuliah berubah');
    expect(result.announcement!.id, '3');
  });

  test('GetAnnouncement meneruskan failure tanpa melempar', () async {
    final repo = FakeAnnouncementRepository(fail: true);
    final result = await GetAnnouncement(repo)('3');
    expect(result.announcement, isNull);
    expect(result.failure, isA<LocalFailure>());
    expect(result.failure!.message, contains('db locked'));
  });

  test('GetAnnouncement menolak id kosong tanpa menyentuh repository', () async {
    final repo = FakeAnnouncementRepository(item: sample);
    final result = await GetAnnouncement(repo)('   ');
    expect(result.announcement, isNull);
    expect(result.failure, isA<NotFoundFailure>());
  });
}
