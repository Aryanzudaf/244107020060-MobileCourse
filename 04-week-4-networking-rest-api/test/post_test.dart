import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:week4_api/data/network_errors.dart';
import 'package:week4_api/data/providers.dart';

import 'fakes.dart';

void main() {
  test('Post.fromJson aman terhadap field yang hilang', () {
    final post = Post.fromJson({'id': 7});
    expect(post.id, 7);
    expect(post.title, '');
    expect(post.body, '');
    expect(post.userId, 0);
  });

  test('Post.fromJson menoleransi tipe angka longgar', () {
    final post = Post.fromJson({
      'userId': 2.0,
      'id': '3', // angka dalam string ikut dikonversi, tidak crash
      'title': 'Halo',
      'body': null,
    });
    expect(post.userId, 2);
    expect(post.id, 3);
    expect(post.title, 'Halo');
    expect(post.body, '');
  });

  test('friendlyErrorMessage untuk connection error', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
    expect(friendlyErrorMessage(err), contains('terhubung'));
  });

  test('friendlyErrorMessage untuk 404', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/posts/99'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/posts/99'),
        statusCode: 404,
      ),
    );
    expect(friendlyErrorMessage(err), contains('404'));
  });

  test('provider sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(
            items: const [Post(userId: 1, id: 1, title: 'Tes', body: 'Isi')],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final posts = await readPostsOnce(container);
    expect(posts.length, 1);
    expect(posts.first.title, 'Tes');
  });

  test('provider error dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider
            .overrideWithValue(FakePostRepository(throwError: true)),
      ],
    );
    addTearDown(container.dispose);

    final err = await readPostsErrorOnce(container);
    expect(err, isA<DioException>());
    expect(friendlyErrorMessage(err!), contains('terhubung'));
  });
}
