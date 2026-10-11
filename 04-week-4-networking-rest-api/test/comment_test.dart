import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/comment.dart';
import 'package:week4_api/data/network_errors.dart';
import 'package:week4_api/data/providers.dart';

import 'fakes.dart';

void main() {
  test('Comment.fromJson aman terhadap field yang hilang', () {
    final comment = Comment.fromJson({'id': 5, 'email': 'x@mail.com'});
    expect(comment.id, 5);
    expect(comment.postId, 0);
    expect(comment.name, '');
    expect(comment.email, 'x@mail.com');
    expect(comment.body, '');
  });

  test('friendlyErrorMessage untuk timeout', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/comments'),
      type: DioExceptionType.receiveTimeout,
    );
    expect(friendlyErrorMessage(err), contains('timeout'));
  });

  test('provider komentar sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        commentRepositoryProvider
            .overrideWithValue(FakeCommentRepository()),
      ],
    );
    addTearDown(container.dispose);

    final comments = await container.read(commentsProvider(1).future);
    expect(comments.length, 1);
    expect(comments.first.name, 'Komen A');
  });
}
