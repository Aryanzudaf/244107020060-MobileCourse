import 'package:dio/dio.dart';

import 'models/comment.dart';
import 'models/post.dart';
import 'repositories/comment_repository.dart';
import 'repositories/post_repository.dart';

/// Repository palsu khusus screenshot demo (tanpa HTTP).
/// Dipakai lewat collection-if di `main.dart` sesuai `?demo=`.
class SeedPostRepository extends PostRepository {
  SeedPostRepository() : super(Dio());

  static const _items = [
    Post(userId: 1, id: 1, title: 'Belajar Dio terpusat', body: 'Base URL dan timeout di satu tempat.'),
    Post(userId: 1, id: 2, title: 'Repository pattern', body: 'UI tidak memanggil Dio langsung.'),
    Post(userId: 2, id: 3, title: 'Pagination 10 per halaman', body: 'Infinite scroll dengan guard ganda.'),
  ];

  @override
  Future<List<Post>> fetchPosts() async => _items;

  @override
  Future<Post> fetchPost(int id) async =>
      _items.firstWhere((p) => p.id == id, orElse: () => _items.first);

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (page > 2) return [];
    return _items;
  }
}

class ErrorPostRepository extends PostRepository {
  ErrorPostRepository() : super(Dio());

  @override
  Future<List<Post>> fetchPosts() async {
    throw DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
  }

  @override
  Future<Post> fetchPost(int id) => fetchPosts().then((_) => throw StateError('unreachable'));

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) {
    return fetchPosts();
  }
}

class EmptyPostRepository extends PostRepository {
  EmptyPostRepository() : super(Dio());

  @override
  Future<List<Post>> fetchPosts() async => [];

  @override
  Future<Post> fetchPost(int id) async =>
      const Post(userId: 0, id: 0, title: '', body: '');

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async => [];
}

class SeedCommentRepository extends CommentRepository {
  SeedCommentRepository() : super(Dio());

  @override
  Future<List<Comment>> fetchComments(int postId) async => const [
        Comment(
          postId: 1,
          id: 1,
          name: 'Aryan Zuda F',
          email: 'aryanzf1@gmail.com',
          body: 'Komentar contoh untuk demo detail post.',
        ),
      ];
}

/// Kelas-kelas di atas dipakai di `main.dart` dengan collection-if,
/// sehingga tipe override disimpulkan otomatis (tipe `Override`
/// tidak diekspor publik oleh flutter_riverpod 3).
