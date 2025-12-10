// =============================
// ✨ Comment Model
// =============================
class Comment {
  final String username;   // 작성자 이름
  final String text;       // 댓글 내용
  final String? avatarUrl; // 프로필 사진 (선택)

  Comment({
    required this.username,
    required this.text,
    this.avatarUrl,
  });
}

// =============================
// Post Model
// =============================
class Post {
  final String username;
  final String userAvatarUrl;

  final String title;
  final String content;

  // ✨ [수정] 이미지가 없을 수도 있으므로 ?(nullable) 추가
  final String? imageUrl;

  // 좋아요/싫어요
  int likes;
  bool isLiked;
  int dislikes;
  bool isDisliked;

  // 댓글 관리
  List<Comment> comments;

  // 정렬/필터링용
  final DateTime createdAt;
  bool isFollowed;

  Post({
    required this.username,
    required this.userAvatarUrl,
    required this.title,
    required this.content,

    // ✨ [수정] required 제거 & 선택적 파라미터로 변경
    this.imageUrl,

    this.likes = 0,
    this.isLiked = false,
    this.dislikes = 0,
    this.isDisliked = false,
    List<Comment>? comments,
    DateTime? createdAt,
    this.isFollowed = false,
  })  : comments = comments ?? [],
        createdAt = createdAt ?? DateTime.now();

  // ---------------------
  // 유틸 메서드
  // ---------------------

  /// 좋아요 toggle
  void toggleLike() {
    if (isLiked) {
      isLiked = false;
      likes--;
    } else {
      isLiked = true;
      likes++;
      if (isDisliked) {
        isDisliked = false;
        dislikes--;
      }
    }
  }

  /// 싫어요 toggle
  void toggleDislike() {
    if (isDisliked) {
      isDisliked = false;
      dislikes--;
    } else {
      isDisliked = true;
      dislikes++;
      if (isLiked) {
        isLiked = false;
        likes--;
      }
    }
  }

  /// 댓글 추가
  void addComment(Comment comment) {
    comments.add(comment);
  }

  /// 댓글 삭제
  void deleteComment(int index) {
    comments.removeAt(index);
  }

  /// 팔로우 토글
  void toggleFollow() {
    isFollowed = !isFollowed;
  }
}

// =============================
// Quote Model
// =============================
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

// =============================
// Scene Models
// =============================
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

// =============================
// Emotion Note Model
// =============================
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