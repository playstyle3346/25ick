import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';

class AppState extends ChangeNotifier {
  // 싱글톤 패턴 (앱 전체에서 하나의 데이터만 공유하기 위함)
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  /// 전체 포스트 저장
  List<Post> posts = [];

  /// 초기 세팅 (앱 실행 시 데이터를 DummyRepository에서 가져옴)
  void initialize() {
    if (posts.isEmpty) {
      posts = List.from(DummyRepository.posts);
    }
    notifyListeners();
  }

  // ============================================================
  // Post 생성
  // ============================================================
  void addPost(Post post) {
    posts.insert(0, post);
    notifyListeners(); // 화면 갱신 알림
  }

  // ============================================================
  // 댓글 추가 / 삭제 (✨ 수정됨)
  // ============================================================
  void addComment(Post post, String text) {
    // ✨ 단순 글자가 아니라 Comment 객체를 생성해서 추가
    final newComment = Comment(
      username: DummyRepository.myName,       // "Jäger"
      text: text,
      avatarUrl: DummyRepository.myProfileImage, // 내 프사
    );

    post.comments.add(newComment);
    notifyListeners();
  }

  void removeComment(Post post, int index) {
    if (index < 0 || index >= post.comments.length) return;
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
      // 좋아요 누르면 싫어요는 취소
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
      // 싫어요 누르면 좋아요는 취소
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
  // 마이페이지 통계 계산 (✨ 실시간 계산으로 변경)
  // ============================================================

  // 1. 내가 쓴 포스트 개수
  int get myPostCount => posts.where((p) => p.username == DummyRepository.myName).length;

  // 2. 내가 쓴 댓글 개수 (모든 포스트를 뒤져서 내 이름으로 된 댓글 카운트)
  int get myCommentCount {
    int count = 0;
    for (var post in posts) {
      count += post.comments.where((c) => c.username == DummyRepository.myName).length;
    }
    return count;
  }

  // 3. 팔로우 수 (내가 팔로우한 사람 수)
  int get myFollowerCount => posts.where((p) => p.isFollowed).length;
}