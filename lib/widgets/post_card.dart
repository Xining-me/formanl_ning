import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers.dart';
import 'package:go_router/go_router.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final bool showActions;
  const PostCard({super.key, required this.post, this.showActions = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnn = post.type == PostType.announcement;
    final color = isAnn ? Theme.of(context).colorScheme.tertiaryContainer : null;

    return InkWell(
      onTap: () => context.push('/post/${post.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(post.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    if (isAnn)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.campaign, size: 16),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(post.content),
                if (showActions) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _IconText(
                        icon: Icons.chat_bubble_outline,
                        text: '\${post.replies}',
                        onTap: () => ref.read(postStoreProvider).addReply(post.id),
                      ),
                      const SizedBox(width: 16),
                      _IconText(
                        icon: Icons.repeat,
                        text: '\${post.reposts}',
                        onTap: () {}, // 占位
                      ),
                      const SizedBox(width: 16),
                      _IconText(
                        icon: Icons.favorite_border,
                        text: '\${post.likes}',
                        onTap: () => ref.read(postStoreProvider).toggleLike(post.id),
                      ),
                      const SizedBox(width: 16),
                      _IconText(
                        icon: Icons.bookmark_border,
                        text: '\${post.bookmarks}',
                        onTap: () => ref.read(postStoreProvider).bookmark(post.id),
                      ),
                    ],
                  ),
                ],
              ]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '\${d.inMinutes} 分钟前';
    if (d.inHours < 24) return '\${d.inHours} 小时前';
    return '\${d.inDays} 天前';
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _IconText({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}
