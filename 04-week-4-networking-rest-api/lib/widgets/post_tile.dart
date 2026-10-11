import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/post.dart';

/// Baris satu post, dipisah agar `ListView.builder` pendek dan mudah diuji.
class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(post.id.toString())),
      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/post/${post.id}', extra: post),
    );
  }
}
