import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  /// 전체 포스트 저장
  List<Post> posts = [];

  /// 내가 작성한 댓글
  List<String> myComments = [];

  /// 팔로우 목록
  List<String> following = [];

  /// 현재 유저
  String currentUser = "나 (Me)";

  /// 초기 세팅 (앱 실행 시 1회만 호출)
  void initialize() {
    posts = List.from(DummyRepository.posts); // ← static 접근으로 변경
    notifyListeners();
  }

  // ============================================================
  // Post 생성
  // ============================================================
  void addPost(Post post) {
    posts.insert(0, post);
    notifyListeners();
  }

  // ============================================================
  // 댓글 추가 / 삭제
  // ============================================================
  void addComment(Post post, String text) {
    post.comments.add(text);
    myComments.add(text);
    notifyListeners();
  }

  void removeComment(Post post, int index) {
    if (index < 0 || index >= post.comments.length) return;
    myComments.remove(post.comments[index]);
    post.comments.removeAt(index);
    notifyListeners();
  }

  // ============================================================
  // 좋아요 / 싫어요
  // ============================================================
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

  // ============================================================
  // 팔로우 / 언팔로우
  // ============================================================
  void toggleFollow(Post post) {
    post.isFollowed = !post.isFollowed;
    notifyListeners();
  }

  // ============================================================
  // 마이페이지 카운트
  // ============================================================
  int get myPostCount => posts.where((p) => p.username == currentUser).length;

  int get myCommentCount => myComments.length;

  int get myFollowerCount => following.length;
}
