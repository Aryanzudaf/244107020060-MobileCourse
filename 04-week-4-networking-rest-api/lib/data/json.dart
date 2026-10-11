/// Konversi defensif untuk field JSON yang tipenya tidak pasti.
/// API nyata kadang mengirim angka sebagai string ("3") atau null.
int jsonInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String jsonStr(Object? value) {
  if (value is String) return value;
  if (value == null) return '';
  return value.toString();
}
