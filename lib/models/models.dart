class Post {
  final String username;
  final String userAvatarUrl;
  final String content;
  final String imageUrl;
  final String title;
  int likes;
  bool isLiked;
  int dislikes;    // 싫어요 수
  bool isDisliked; // 싫어요 눌렀는지 여부
  List<String> comments;

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
  }) : this.comments = comments ?? [];
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