import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentCtrl = TextEditingController();
  bool _isAnnouncement = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('发布帖子')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _contentCtrl,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: '内容',
                    hintText: '分享你的想法…',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? '内容不能为空' : null,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _isAnnouncement,
                  onChanged: (v) => setState(() => _isAnnouncement = v),
                  title: const Text('设为公告（置顶权重更高）'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('发布'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    ref.read(postStoreProvider).create(
                          authorId: user.id,
                          authorName: user.nickname,
                          authorAvatar: user.avatarUrl,
                          content: _contentCtrl.text.trim(),
                          isAnnouncement: _isAnnouncement,
                        );
                    context.pop();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
