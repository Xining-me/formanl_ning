enum PostType { normal, announcement }

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final PostType type;
  final List<String> imageUrls;
  final String? club; // 参加社团 feed 用
  final String? replyToPostId;

  int likes;
  int replies;
  int reposts;
  int bookmarks;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    required this.type,
    this.imageUrls = const [],
    this.club,
    this.replyToPostId,
    this.likes = 0,
    this.replies = 0,
    this.reposts = 0,
    this.bookmarks = 0,
  });
}
