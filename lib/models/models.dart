import 'dart:typed_data';

/// =============================
/// 댓글 모델
/// =============================
class Comment {
  final String username;    // 작성자 이름
  final String text;        // 댓글 내용
  final String? avatarUrl;  // 프로필 이미지 (선택)

  Comment({
    required this.username,
    required this.text,
    this.avatarUrl,
  });
}

/// =============================
/// 커뮤니티 포스트 모델
///  - imageUrl: 에셋 이미지
///  - imageBytes: 업로드 이미지
/// =============================
class Post {
  final String username;
  final String userAvatarUrl;

  final String title;
  final String content;

  /// 에셋 이미지 경로
  final String? imageUrl;

  /// 업로드 이미지
  final Uint8List? imageBytes;

  // 좋아요/싫어요
  int likes;
  bool isLiked;
  int dislikes;
  bool isDisliked;

  // 댓글 리스트
  List<Comment> comments;

  // 정렬/필터링
  final DateTime createdAt;
  bool isFollowed;

  Post({
    required this.username,
    required this.userAvatarUrl,
    required this.title,
    required this.content,
    this.imageUrl,
    this.imageBytes,
    this.likes = 0,
    this.isLiked = false,
    this.dislikes = 0,
    this.isDisliked = false,
    List<Comment>? comments,
    DateTime? createdAt,
    this.isFollowed = false,
  })  : comments = comments ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// 좋아요 토글
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

  /// 싫어요 토글
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
  void addComment(Comment comment) => comments.add(comment);

  /// 댓글 삭제
  void deleteComment(int index) => comments.removeAt(index);

  /// 팔로우 토글
  void toggleFollow() => isFollowed = !isFollowed;
}

/// =============================
/// 명대사 모델 (Quote)
///  - imageUrl: 에셋 이미지
///  - imageBytes: 업로드 이미지
/// =============================
class Quote {
  String text;
  String source;
  String? imageUrl;
  Uint8List? imageBytes;

  Quote({
    required this.text,
    required this.source,
    this.imageUrl,
    this.imageBytes,
  });
}

/// =============================
/// 장면(Scene) 모델
/// =============================
class SceneItem {
  String? imageUrl;       // 에셋 이미지
  Uint8List? imageBytes;  // 업로드 이미지

  SceneItem({
    this.imageUrl,
    this.imageBytes,
  });
}

class SceneGroup {
  String title;
  List<SceneItem> scenes;

  SceneGroup({
    required this.title,
    required this.scenes,
  });
}

/// =============================
/// 감성노트 모델
/// =============================
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
