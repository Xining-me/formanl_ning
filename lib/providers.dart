import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'models/post.dart';
import 'data/mock_data.dart';
import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

/// --- Auth 状态（学生号+邮箱 简单校验，本地持久化） ---
class AuthState extends ChangeNotifier {
  AppUser? currentUser;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('auth_user');
    if (raw != null) {
      try {
        final Map<String, dynamic> m = jsonDecode(raw) as Map<String, dynamic>;
        final followingList = (m['following'] as List?)?.cast<String>() ?? <String>[];
        final favList = (m['favorites'] as List?)?.cast<String>() ?? <String>[];
        currentUser = AppUser(
          id: m['id'] as String,
          nickname: m['nickname'] as String,
          avatarUrl: m['avatarUrl'] as String,
          bannerUrl: m['bannerUrl'] as String,
          bio: m['bio'] as String,
          registeredAt: DateTime.parse(m['registeredAt'] as String),
          studentId: m['studentId'] as String,
          email: m['email'] as String,
          followingUserIds: followingList.toSet(),
          favoritePostIds: favList.toSet(),
        );
      } catch (_) {
        // 如果解析失败，则忽略本地存储（避免抛异常阻断加载）
        currentUser = null;
      }
    }
    notifyListeners();
  }

  Future<bool> login({required String studentId, required String email}) async {
    // 简单规则：studentId 与 email 非空即“登录”；真实项目替换为后端/Firebase
    final AppUser base = demoUser;
    currentUser = AppUser(
      id: base.id,
      nickname: base.nickname,
      avatarUrl: base.avatarUrl,
      bannerUrl: base.bannerUrl,
      bio: base.bio,
      registeredAt: base.registeredAt,
      studentId: studentId,
      email: email,
      followingUserIds: base.followingUserIds,
      favoritePostIds: base.favoritePostIds,
    );
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    currentUser = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove('auth_user');
    notifyListeners();
  }

  Future<void> updateProfile({
    String? nickname,
    String? bio,
  }) async {
    if (currentUser == null) return;
    currentUser!.nickname = nickname ?? currentUser!.nickname;
    currentUser!.bio = bio ?? currentUser!.bio;
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    if (currentUser == null) return;
    final sp = await SharedPreferences.getInstance();
    final m = {
      'id': currentUser!.id,
      'nickname': currentUser!.nickname,
      'avatarUrl': currentUser!.avatarUrl,
      'bannerUrl': currentUser!.bannerUrl,
      'bio': currentUser!.bio,
      'registeredAt': currentUser!.registeredAt.toIso8601String(),
      'studentId': currentUser!.studentId,
      'email': currentUser!.email,
      'following': currentUser!.followingUserIds.toList(),
      'favorites': currentUser!.favoritePostIds.toList(),
    };
    await sp.setString('auth_user', jsonEncode(m));
  }
}

final authProvider = ChangeNotifierProvider<AuthState>((ref) => AuthState());

/// --- 帖子数据（本地内存+持久化快照） ---
class PostStore extends ChangeNotifier {
  final List<Post> _posts = [];
  bool _inited = false;

  List<Post> get posts => List.unmodifiable(_posts);

  Future<void> init() async {
    if (_inited) return;
    _posts.clear();
    _posts.addAll(seedPosts());
    _inited = true;
    notifyListeners();
  }

  List<Post> latest() {
    final cp = [..._posts];
    cp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return cp;
  }

  List<Post> following(Set<String> followingIds) {
    final cp = _posts.where((p) => followingIds.contains(p.authorId)).toList();
    cp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return cp;
  }

  List<Post> byClub(String? club) {
    final cp = _posts.where((p) => p.club != null).toList();
    cp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return cp;
  }

  List<Post> announcementsTop10() {
    final ann = _posts.where((p) => p.type == PostType.announcement).toList();
    ann.sort((a, b) =>
        (b.likes + b.replies + b.bookmarks).compareTo(a.likes + a.replies + a.bookmarks));
    return ann.take(10).toList();
  }

  List<Post> trendsTop10() {
    final cp = [..._posts];
    cp.sort((a, b) => (b.likes + b.replies + b.reposts + b.bookmarks)
        .compareTo(a.likes + a.replies + a.reposts + a.bookmarks));
    return cp.take(10).toList();
  }

  /// 更稳健的查找：如果找不到返回 null（避免不安全的类型强转）
  Post? findById(String id) {
    try {
      return _posts.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Post create({
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
    required bool isAnnouncement,
    String? club,
    List<String> images = const [],
    String? replyToPostId,
  }) {
    final p = Post(
      id: _uuid.v4(),
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      content: content,
      createdAt: DateTime.now(),
      type: isAnnouncement ? PostType.announcement : PostType.normal,
      club: club,
      imageUrls: images,
      replyToPostId: replyToPostId,
    );
    _posts.insert(0, p);
    notifyListeners();
    return p;
  }

  void toggleLike(String postId) {
    final p = _posts.firstWhere((e) => e.id == postId, orElse: () => throw StateError('post not found'));
    p.likes += 1;
    notifyListeners();
  }

  void addReply(String postId) {
    final p = _posts.firstWhere((e) => e.id == postId, orElse: () => throw StateError('post not found'));
    p.replies += 1;
    notifyListeners();
  }

  void bookmark(String postId) {
    final p = _posts.firstWhere((e) => e.id == postId, orElse: () => throw StateError('post not found'));
    p.bookmarks += 1;
    notifyListeners();
  }
}

final postStoreProvider = ChangeNotifierProvider<PostStore>((ref) => PostStore());
