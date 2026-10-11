import '../json.dart';

/// Comment dari `GET /comments?postId={id}`. Konversi defensif sama
/// seperti [Post] agar aman null.
class Comment {
  const Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: jsonInt(json['postId']),
      id: jsonInt(json['id']),
      name: jsonStr(json['name']),
      email: jsonStr(json['email']),
      body: jsonStr(json['body']),
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'id': id,
        'name': name,
        'email': email,
        'body': body,
      };
}
