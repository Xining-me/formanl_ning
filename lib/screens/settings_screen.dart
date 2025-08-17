import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nickCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = ref.read(authProvider).currentUser!;
    _nickCtrl.text = u.nickname;
    _bioCtrl.text = u.bio;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nickCtrl,
            decoration: const InputDecoration(labelText: '昵称'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bioCtrl,
            decoration: const InputDecoration(labelText: '个人简介'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await auth.updateProfile(nickname: _nickCtrl.text.trim(), bio: _bioCtrl.text.trim());
              if (mounted) context.pop();
            },
            child: const Text('保存资料'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await auth.logout();
              if (mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('退出登录'),
          ),
          const SizedBox(height: 16),
          const Text('隐私设置（示例占位）\n• 谁可以评论我\n• 谁可以给我发消息', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
