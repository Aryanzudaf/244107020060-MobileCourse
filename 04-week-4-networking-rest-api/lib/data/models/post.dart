import '../json.dart';

/// Post dari `GET /posts`. Konversi defensif agar field hilang/berubah
/// tipe tidak membuat aplikasi crash.
class Post {
  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: jsonInt(json['userId']),
      id: jsonInt(json['id']),
      title: jsonStr(json['title']),
      body: jsonStr(json['body']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
