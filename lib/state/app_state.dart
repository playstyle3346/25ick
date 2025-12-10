import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  /// 전체 포스트 저장
  List<Post> posts = [];

  /// 초기 세팅 (앱 실행 시 DummyRepository 로드)
  void initialize() {
    if (posts.isEmpty) {
      posts = List.from(DummyRepository.posts);
    }
    notifyListeners();
  }

  // ================================
  // 포스트 추가
  // ================================
  void addPost(Post post) {
    posts.insert(0, post);
    notifyListeners();
  }

  // ================================
  // 댓글 추가 / 삭제 (✨ avatarUrl 안정화)
  // ================================
  void addComment(Post post, String text) {
    final avatar = DummyRepository.myProfileImage.isNotEmpty
        ? DummyRepository.myProfileImage
        : 'assets/posters/insideout.jpg'; // ✅ fallback

    final newComment = Comment(
      username: DummyRepository.myName.isNotEmpty
          ? DummyRepository.myName
          : "익명",
      text: text,
      avatarUrl: avatar,
    );

    post.comments.add(newComment);
    notifyListeners();
  }

  void removeComment(Post post, int index) {
    if (index < 0 || index >= post.comments.length) return;
    post.comments.removeAt(index);
    notifyListeners();
  }

  // ================================
  // 좋아요 / 싫어요
  // ================================
  void toggleLike(Post post) {
    if (post.isLiked) {
      post.likes--;
      post.isLiked = false;
    } else {
      post.likes++;
      post.isLiked = true;
      if (post.isDisliked) {
        post.dislikes--;
        post.isDisliked = false;
      }
    }
    notifyListeners();
  }

  void toggleDislike(Post post) {
    if (post.isDisliked) {
      post.dislikes--;
      post.isDisliked = false;
    } else {
      post.dislikes++;
      post.isDisliked = true;
      if (post.isLiked) {
        post.likes--;
        post.isLiked = false;
      }
    }
    notifyListeners();
  }

  // ================================
  // 팔로우 / 언팔로우
  // ================================
  void toggleFollow(Post post) {
    post.isFollowed = !post.isFollowed;
    notifyListeners();
  }

  // ================================
  // 마이페이지 통계
  // ================================
  int get myPostCount =>
      posts.where((p) => p.username == DummyRepository.myName).length;

  int get myCommentCount {
    int count = 0;
    for (var post in posts) {
      count += post.comments
          .where((c) => c.username == DummyRepository.myName)
          .length;
    }
    return count;
  }

  int get myFollowerCount =>
      posts.where((p) => p.isFollowed).length;
}
