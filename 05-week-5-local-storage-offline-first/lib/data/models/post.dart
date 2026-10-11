/// Post ringan untuk demo cache-first (dari `GET /posts` Week 4).
class Post {
  const Post({required this.id, required this.title});

  final int id;
  final String title;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
    );
  }
}
