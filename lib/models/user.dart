class AppUser {
  final String id;
  String nickname;
  String avatarUrl;
  String bannerUrl;
  String bio;
  final DateTime registeredAt;
  final String studentId;
  final String email;
  final Set<String> followingUserIds;
  final Set<String> favoritePostIds;

  AppUser({
    required this.id,
    required this.nickname,
    required this.avatarUrl,
    required this.bannerUrl,
    required this.bio,
    required this.registeredAt,
    required this.studentId,
    required this.email,
    Set<String>? followingUserIds,
    Set<String>? favoritePostIds,
  })  : followingUserIds = followingUserIds ?? {},
        favoritePostIds = favoritePostIds ?? {};
}
