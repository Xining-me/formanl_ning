import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(postStoreProvider);
    final post = store.posts.firstWhere((p) => p.id == postId);
    return Scaffold(
      appBar: AppBar(title: const Text('帖子详情')),
      body: ListView(
        children: [
          PostCard(post: post, showActions: true),
          const Divider(),
          const ListTile(title: Text('回复（示例）')),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('同学A'),
            subtitle: Text('一起讨论下周作业吧～'),
          ),
        ],
      ),
    );
  }
}
