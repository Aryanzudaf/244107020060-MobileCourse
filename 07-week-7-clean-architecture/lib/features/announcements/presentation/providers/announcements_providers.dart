import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/announcement_repository_impl.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/usecases/get_announcement.dart';

// ============================================================================
// Dependency injection: satu-satunya tempat wiring.
// ============================================================================

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => AnnouncementRepositoryImpl(),
);

final getAnnouncementProvider = Provider<GetAnnouncement>(
  (ref) => GetAnnouncement(ref.watch(announcementRepositoryProvider)),
);

/// Presentation state: hasil use case per id. Failure sengaja dilempar
/// sebagai error state sehingga UI hanya perlu menampilkan `message`.
///
/// `retry` dimatikan: failure di sini deterministik (data statis — id tak
/// dikenal akan selalu gagal), sehingga retry otomatis Riverpod 3 (backoff
/// hingga 10x, total ±40 dtk spinner) hanya menunda error state yang pasti.
/// Untuk sumber transient (jaringan), teruskan `retry` default.
final announcementProvider =
    FutureProvider.family<Announcement, String>(
      (ref, id) async {
        final result = await ref.watch(getAnnouncementProvider).call(id);
        final failure = result.failure;
        if (failure != null) throw failure;
        return result.announcement!;
      },
      retry: (_, _) => null,
    );
