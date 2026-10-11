import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'models/comment.dart';
import 'models/post.dart';
import 'network_errors.dart';
import 'repositories/comment_repository.dart';
import 'repositories/post_repository.dart';

final dioProvider = Provider<Dio>((ref) => createDio());

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(ref.watch(dioProvider)),
);

final commentRepositoryProvider = Provider<CommentRepository>(
  (ref) => CommentRepository(ref.watch(dioProvider)),
);

/// Daftar penuh untuk halaman `/simple`.
class PostListNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final repository = ref.watch(postRepositoryProvider);
    return repository.fetchPosts();
  }

  /// Refresh manual: tampilkan loading, lalu data baru atau error.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).fetchPosts(),
    );
  }
}

final postListProvider =
    AsyncNotifierProvider<PostListNotifier, List<Post>>(
  PostListNotifier.new,
  // Nonaktifkan retry otomatis Riverpod 3 agar error final dan mudah diuji.
  retry: (retryCount, error) => null,
);

/// Detail satu post: pakai `extra` bila dibuka dari daftar,
/// ambil ulang dari repository bila dibuka langsung (deep link).
class PostDetailNotifier extends AsyncNotifier<Post> {
  PostDetailNotifier(this.id, {this.initial});

  final int id;
  final Post? initial;

  @override
  Future<Post> build() async {
    if (initial != null) return initial!;
    return ref.watch(postRepositoryProvider).fetchPost(id);
  }
}

final postDetailProvider = AsyncNotifierProvider.family<
    PostDetailNotifier, Post, ({int id, Post? initial})>(
  (args) => PostDetailNotifier(args.id, initial: args.initial),
  retry: (retryCount, error) => null,
);

/// Komentar satu post.
class CommentsNotifier extends AsyncNotifier<List<Comment>> {
  CommentsNotifier(this.postId);

  final int postId;

  @override
  Future<List<Comment>> build() {
    return ref.watch(commentRepositoryProvider).fetchComments(postId);
  }
}

final commentsProvider =
    AsyncNotifierProvider.family<CommentsNotifier, List<Comment>, int>(
  (postId) => CommentsNotifier(postId),
  retry: (retryCount, error) => null,
);

/// Helper khusus testing: state pertama yang bukan loading.
Future<List<Post>> readPostsOnce(ProviderContainer container) {
  final completer = Completer<List<Post>>();
  final sub = container.listen<AsyncValue<List<Post>>>(
    postListProvider,
    (previous, next) {
      if (next.isLoading || completer.isCompleted) return;
      next.whenData(completer.complete);
      if (next.hasError) {
        completer.completeError(
          next.error ?? StateError('unknown error'),
          next.stackTrace ?? StackTrace.empty,
        );
      }
    },
    fireImmediately: true,
  );
  return completer.future.whenComplete(sub.close);
}

Future<Object?> readPostsErrorOnce(ProviderContainer container) {
  final completer = Completer<Object?>();
  final sub = container.listen<AsyncValue<List<Post>>>(
    postListProvider,
    (previous, next) {
      if (next.isLoading || completer.isCompleted) return;
      completer.complete(next.error);
    },
    fireImmediately: true,
  );
  return completer.future.whenComplete(sub.close);
}

/// Pesan error diekspor ulang agar halaman cukup import satu tempat.
String userMessage(Object error) => friendlyErrorMessage(error);
