import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  const PostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text('这里还没有内容～'));
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (_, i) => PostCard(post: posts[i]),
    );
  }
}
