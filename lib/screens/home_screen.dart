import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';
import '../widgets/post_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    ref.read(postStoreProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    if (auth.currentUser == null) {
      Future.microtask(() => context.go('/login'));
    }
    final postStore = ref.watch(postStoreProvider);
    final followingIds = auth.currentUser?.followingUserIds ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusTweet'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: '最新发帖'),
            Tab(text: '正在关注'),
            Tab(text: '参加社团'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
            tooltip: '搜索',
          ),
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          PostList(posts: postStore.latest()),
          PostList(posts: postStore.following(followingIds)),
          PostList(posts: postStore.byClub(null)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/compose'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
