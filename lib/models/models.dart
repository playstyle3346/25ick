class Post {
  final String username;
  final String userAvatarUrl;
  final String content;
  final String imageUrl;
  final String title;
  int likes;
  bool isLiked;
  List<String> comments;

  Post({
    required this.username,
    required this.userAvatarUrl,
    required this.content,
    required this.imageUrl,
    required this.title,
    this.likes = 0,
    this.isLiked = false,
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