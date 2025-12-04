class Post {
  final String username;
  final String userAvatarUrl;
  final String content;
  final String imageUrl;
  final String title;

  // 좋아요/싫어요
  int likes;
  bool isLiked;
  int dislikes;
  bool isDisliked;

  // 댓글
  List<String> comments;

  // ✨ 정렬 및 필터링을 위한 필수 데이터
  final DateTime createdAt; // 작성 시간
  final bool isFollowed;    // 팔로우 여부

  Post({
    required this.username,
    required this.userAvatarUrl,
    required this.content,
    required this.imageUrl,
    required this.title,
    this.likes = 0,
    this.isLiked = false,
    this.dislikes = 0,
    this.isDisliked = false,
    List<String>? comments,
    DateTime? createdAt,
    this.isFollowed = false,
  }) :
        this.comments = comments ?? [],
        this.createdAt = createdAt ?? DateTime.now(); // 시간 없으면 현재 시간으로 설정
}

class Quote {
  String text;
  String source;
  String imageUrl;

  Quote({
    required this.text,
    required this.source,
    required this.imageUrl,
  });
}

class SceneItem {
  String imageUrl;
  SceneItem({required this.imageUrl});
}

class SceneGroup {
  String title;
  List<SceneItem> scenes;

  SceneGroup({
    required this.title,
    required this.scenes,
  });
}

class EmotionNote {
  String title;
  String body;
  DateTime date;

  EmotionNote({
    required this.title,
    required this.body,
    required this.date,
  });
}