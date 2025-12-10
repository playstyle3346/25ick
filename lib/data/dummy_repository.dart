import '../models/models.dart';

class DummyRepository {
  // ====================================================
  // 로그인한 유저 정보
  // ====================================================

  static String myName = "Guest";
  static String myProfileImage = "assets/posters/insideout.jpg";

  static int myCommentCount = 0;

  static void setLoggedInUser(String name, String profileImage) {
    myName = name;
    myProfileImage = profileImage.isNotEmpty
        ? profileImage
        : "assets/posters/insideout.jpg";
  }

  // ====================================================
  // 포스트 추가 / 삭제
  // ====================================================

  static void addPost(Post newPost) {
    posts.insert(0, newPost);
  }

  static void deletePost(Post post) {
    posts.remove(post);
  }

  static void incrementCommentCount() {
    myCommentCount++;
  }

  // ====================================================
  // 더미 데이터
  // ====================================================

  static final List<String> _postContents = [
    '“사람들은 다른 사람의 열정에 끌리게 되어있어.\n자신이 잊은 걸 상기시켜 주니까.”',
    '“우린 답을 찾을 것이다. 늘 그랬듯이.”',
    '“가장 완벽한 계획이 뭔지 알아? 무계획이야.”',
    '“세상에서 제일 쓸모없고 해로운 말이 ‘그만하면 잘했어’야.”',
    '“아빠가 널 끝까지 지켜줄 거란다.”',
  ];

  static final List<String> _movieTitles = [
    'La La Land (2016)',
    'Interstellar (2014)',
    '기생충 (2019)',
    'Whiplash (2014)',
    '부산행 (2016)',
  ];

  static final List<String> _moviePosters = [
    'assets/posters/lalaland.jpg',
    'assets/posters/interstellar.jpg',
    'assets/posters/parasite.jpg',
    'assets/posters/whiplash.jpg',
    'assets/posters/train_to_busan.jpg',
  ];

  static List<Post> posts = List.generate(5, (index) {
    return Post(
      username: 'MovieFan ${index + 1}',
      userAvatarUrl: index % 2 == 0
          ? 'assets/posters/insideout.jpg'
          : 'assets/posters/getout.jpg',
      title: _movieTitles[index],
      content: _postContents[index],
      imageUrl: _moviePosters[index],
      likes: 0,
      dislikes: 0,
      comments: [],
      createdAt: DateTime.now().subtract(Duration(hours: index * 5)),
      isFollowed: false,
      isLiked: false,
      isDisliked: false,
    );
  });

  static final List<Quote> quotes = [
    Quote(
      text: "I am Iron Man.",
      source: "Avengers: Endgame",
      imageUrl: "assets/posters/avengers.jpg",
    ),
    Quote(
      text: "인생은 초콜릿 상자와 같은 거야.",
      source: "Forrest Gump",
      imageUrl: "assets/posters/forrestgump.jpg",
    ),
    Quote(
      text: "Let it go!",
      source: "Frozen (2013)",
      imageUrl: "assets/posters/frozen.jpg",
    ),
    Quote(
      text: "절대 포기하지 마라.",
      source: "Whiplash",
      imageUrl: "assets/posters/whiplash.jpg",
    ),
  ];

  static final List<SceneGroup> sceneGroups = [
    SceneGroup(
      title: "Best Movies",
      scenes: [
        SceneItem(imageUrl: "assets/posters/interstellar.jpg"),
        SceneItem(imageUrl: "assets/posters/avengers.jpg"),
        SceneItem(imageUrl: "assets/posters/train_to_busan.jpg"),
      ],
    ),
  ];

  static final List<EmotionNote> notes = [
    EmotionNote(
      title: "오늘 '인사이드 아웃'을 보고",
      body: "빙봉 장면 너무 슬펐다...",
      date: DateTime(2025, 12, 10),
    ),
  ];
}
