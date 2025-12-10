import 'dart:typed_data';

/// =============================
/// 댓글 모델
/// =============================
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

/// =============================
/// 커뮤니티 포스트 모델
///  - 에셋 포스터: imageUrl (선택)
///  - 업로드 이미지: imageBytes (선택)
/// =============================
class Post {
  final String username;
  final String userAvatarUrl;

  final String title;
  final String content;

  /// 에셋 이미지 경로 (예: "assets/posters/insideout.jpg")
  final String? imageUrl;

  /// 사용자가 업로드한 이미지 (웹/앱 공통)
  final Uint8List? imageBytes;

  int likes;
  bool isLiked;
  int dislikes;
  bool isDisliked;

  List<Comment> comments;

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

  /// ---------------------
  /// 유틸 메서드
  /// ---------------------
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

  void addComment(Comment comment) {
    comments.add(comment);
  }

  void deleteComment(int index) {
    comments.removeAt(index);
  }

  void toggleFollow() {
    isFollowed = !isFollowed;
  }
}

/// =============================
/// 명대사 모델
///  - 기존 에셋 포스터: imageUrl
///  - 새로 업로드: imageBytes
/// =============================
class Quote {
  String text;           // 대사 내용
  String source;         // 영화 제목 등
  String? imageUrl;      // 에셋 이미지 경로
  Uint8List? imageBytes; // 업로드 이미지

  Quote({
    required this.text,
    required this.source,
    this.imageUrl,
    this.imageBytes,
  });
}

/// =============================
/// 장면 모델
///  - 에셋 포스터: imageUrl
///  - 새로 업로드: imageBytes
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
/// 감성 노트 모델
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
