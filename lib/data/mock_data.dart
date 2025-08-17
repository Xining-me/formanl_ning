import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/post.dart';

final _uuid = const Uuid();

final AppUser demoUser = AppUser(
  id: 'u1',
  nickname: '李群彦',
  avatarUrl: '',
  bannerUrl: '',
  bio: '经济学与金融学｜热爱校园活动',
  registeredAt: DateTime(2024, 9, 1),
  studentId: '2023123456',
  email: 'user@example.com',
);

final List<AppUser> users = [
  demoUser,
  AppUser(
    id: 'u2',
    nickname: '社团联合会',
    avatarUrl: '',
    bannerUrl: '',
    bio: '官方公告账号',
    registeredAt: DateTime(2023, 3, 1),
    studentId: '0000000000',
    email: 'union@example.com',
  ),
];

List<Post> seedPosts() {
  final now = DateTime.now();
  return [
    Post(
      id: _uuid.v4(),
      authorId: 'u2',
      authorName: '社团联合会',
      authorAvatar: '',
      content: '【公告】本周五晚 19:00 体育馆社团之夜，欢迎参加！',
      createdAt: now.subtract(const Duration(hours: 2)),
      type: PostType.announcement,
      club: '校园社团',
      likes: 42,
      replies: 5,
      reposts: 8,
      bookmarks: 12,
    ),
    Post(
      id: _uuid.v4(),
      authorId: 'u1',
      authorName: '李群彦',
      authorAvatar: '',
      content: '今天计量经济学作业好难…有同学一起讨论吗？',
      createdAt: now.subtract(const Duration(hours: 3)),
      type: PostType.normal,
      likes: 18,
      replies: 6,
    ),
    Post(
      id: _uuid.v4(),
      authorId: 'u1',
      authorName: '李群彦',
      authorAvatar: '',
      content: '金融市场小组讨论资料已更新到云盘～',
      createdAt: now.subtract(const Duration(days: 1, hours: 1)),
      type: PostType.normal,
      bookmarks: 3,
    ),
  ];
}
