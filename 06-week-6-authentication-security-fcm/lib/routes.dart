/// Rute terpusat agar deep link FCM dan GoRouter memakai konstanta sama.
class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcementDetail = '/pengumuman/:id';

  static String announcement(String id) => '/pengumuman/$id';
}

/// Topik broadcast kampus + endpoint pendaftaran token perangkat.
class PushConfig {
  static const topic = 'pengumuman-kampus';
  static const devicesEndpoint = '/devices';
}
