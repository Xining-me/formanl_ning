import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../widgets/post_list.dart';

class ProfileScreen extends ConsumerWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final store = ref.watch(postStoreProvider);
    final isMe = auth.currentUser?.id == uid;
    final user = auth.currentUser!; // 演示用：本地仅一名登录用户

    final posts = store.latest().where((p) => p.authorId == uid).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isMe ? '我的主页' : '用户主页'),
        actions: [
          if (isMe)
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              icon: const Icon(Icons.edit),
              tooltip: '编辑资料',
            ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 120,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          ListTile(
            leading: const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            title: Text(user.nickname, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text(user.bio),
            trailing: Text('注册于 ${user.registeredAt.toLocal().toString().split(' ').first}'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('发布的帖子', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          PostList(posts: posts),
        ],
      ),
    );
  }
}
