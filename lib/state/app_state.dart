import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  /// ------------------------------
  /// 🔥 로그인한 사용자 정보 저장 (추가된 부분)
  /// ------------------------------
  String userNickname = DummyRepository.myName.isNotEmpty
      ? DummyRepository.myName
      : "Guest";

  String userAvatar = DummyRepository.myProfileImage;

  void setUser(String nickname, String avatarPath) {
    userNickname = nickname;
    userAvatar = avatarPath;
    notifyListeners();
  }

  /// 전체 포스트 저장
  List<Post> posts = [];

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
// 댓글 추가 / 삭제
// ================================
  Future<String> _getCurrentNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("nickname") ?? "익명";
  }

  void addComment(Post post, String text) async {
    final nickname = await _getCurrentNickname();
    final avatar = DummyRepository.myProfileImage;

    final newComment = Comment(
      username: nickname,
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
  // 팔로우
  // ================================
  void toggleFollow(Post post) {
    post.isFollowed = !post.isFollowed;
    notifyListeners();
  }

  // ================================
  // 마이페이지 통계
  // ================================
  int get myPostCount =>
      posts.where((p) => p.username == userNickname).length;

  int get myCommentCount {
    int count = 0;
    for (var post in posts) {
      count += post.comments.where((c) => c.username == userNickname).length;
    }
    return count;
  }

  int get myFollowerCount =>
      posts.where((p) => p.isFollowed).length;
}
