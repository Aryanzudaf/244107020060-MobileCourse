import 'package:dio/dio.dart';

import '../models/post.dart';

/// Pintu ke endpoint posts untuk refresh cache.
class PostRepository {
  PostRepository(this._dio);

  final Dio _dio;

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get<List>('/posts');
    final data = response.data ?? [];
    return data.whereType<Map<String, dynamic>>().map(Post.fromJson).toList();
  }
}
