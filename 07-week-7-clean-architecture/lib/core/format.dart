/// Fungsi murni tanpa Flutter/Dio: aman diuji tanpa widget dan bebas
/// dipakai data layer maupun presentation.
library;

/// Data payload push -> rute deep link. Selalu kembalikan path ber-slash.
String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route']?.toString() ?? '/';
  return route.startsWith('/') ? route : '/$route';
}

/// Token penuh tidak pernah tampil di UI/log: 12 karakter pertama + `...`.
String tokenPreview(String? token) {
  if (token == null || token.isEmpty) return '-';
  final head = token.length <= 12 ? token : token.substring(0, 12);
  return '$head...';
}
