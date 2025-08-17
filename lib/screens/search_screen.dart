import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../widgets/post_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
  final _queryCtrl = TextEditingController();
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(postStoreProvider);
    final results = store.latest().where((p) => p.content.contains(_queryCtrl.text)).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryCtrl,
          decoration: const InputDecoration(
            hintText: '搜索帖子 / 用户 / 社团',
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
        ),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: '趋势 Top10'),
            Tab(text: '公告 Top10'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          PostList(posts: _queryCtrl.text.isEmpty ? store.trendsTop10() : results),
          PostList(posts: store.announcementsTop10()),
        ],
      ),
    );
  }
}
