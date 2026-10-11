import 'package:dio/dio.dart';
import 'package:week4_api/data/models/comment.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:week4_api/data/repositories/comment_repository.dart';
import 'package:week4_api/data/repositories/post_repository.dart';

/// Repository palsu untuk test (tanpa HTTP sungguhan).
class FakePostRepository extends PostRepository {
  FakePostRepository({this.items, this.throwError = false}) : super(Dio());

  final List<Post>? items;
  final bool throwError;

  @override
  Future<List<Post>> fetchPosts() async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionError,
      );
    }
    return items ?? const [];
  }

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) {
    return fetchPosts();
  }

  @override
  Future<Post> fetchPost(int id) async {
    final found = (items ?? const []).where((p) => p.id == id);
    if (found.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: '/posts/$id'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/posts/$id'),
          statusCode: 404,
        ),
      );
    }
    return found.first;
  }
}

class FakeCommentRepository extends CommentRepository {
  FakeCommentRepository({this.throwError = false}) : super(Dio());

  final bool throwError;

  @override
  Future<List<Comment>> fetchComments(int postId) async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: '/comments'),
        type: DioExceptionType.receiveTimeout,
      );
    }
    return const [
      Comment(
        postId: 1,
        id: 1,
        name: 'Komen A',
        email: 'a@mail.com',
        body: 'Isi komentar A',
      ),
    ];
  }
}
