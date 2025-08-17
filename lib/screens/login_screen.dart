import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(authProvider).load().then((_) {
      final u = ref.read(authProvider).currentUser;
      if (u != null && mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('校园账号登录', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _studentCtrl,
                        decoration: const InputDecoration(labelText: '学生号', prefixIcon: Icon(Icons.badge_outlined)),
                        validator: (v) => (v == null || v.isEmpty) ? '请输入学生号' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: '邮箱', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (v) => (v == null || !v.contains('@')) ? '请输入有效邮箱' : null,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final ok = await ref.read(authProvider).login(
                                studentId: _studentCtrl.text.trim(),
                                email: _emailCtrl.text.trim(),
                              );
                          if (ok && mounted) context.go('/');
                        },
                        child: const Text('登录'),
                      )
                    ])))),
          ),
        ),
      ),
    );
  }
}
