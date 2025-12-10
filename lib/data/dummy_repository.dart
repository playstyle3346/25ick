import '../models/models.dart';

class DummyRepository {
  // ====================================================
  // [핵심 1] 로그인한 유저 정보 & 통계 데이터
  // ====================================================

  // 로그인 상태에 따라 이름이 바뀝니다. (기본값: Guest)
  static String myName = "Guest";
  static String myProfileImage = "assets/posters/insideout.jpg";

  // [추가] 내가 쓴 댓글 개수 (마이페이지 연동용)
  static int myCommentCount = 0;

  // ----------------------------------------------------
  // [기능] 로그인/회원가입 성공 시 호출 -> 내 이름을 기억함!
  // ----------------------------------------------------
  static void setLoggedInUser(String name, String profileImage) {
    myName = name;
    myProfileImage = profileImage;
  }

  // ----------------------------------------------------
  // [기능] 새 포스트 저장 (마이페이지 '내가 쓴 글' 카운팅 & 홈 화면 추가)
  // ----------------------------------------------------
  static void addPost(Post newPost) {
    // 리스트의 맨 앞(0번 인덱스)에 추가해야 최신글로 뜹니다.
    posts.insert(0, newPost);
  }

  // ----------------------------------------------------
  // [기능] 댓글 개수 증가 (마이페이지 '작성한 댓글' 카운팅)
  // ----------------------------------------------------
  static void incrementCommentCount() {
    myCommentCount++;
  }


  // ====================================================
  // [기존 데이터] 변경 없이 그대로 유지
  // ====================================================

  static const String placeholder = "assets/posters/lalaland.jpg";

  static final List<String> _postContents = [
    '“사람들은 다른 사람의 열정에 끌리게 되어있어.\n자신이 잊은 걸 상기시켜 주니까.”\n\n꿈을 꾸는 사람들을 위한 별들의 도시, 라라랜드.',
    '“우린 답을 찾을 것이다. 늘 그랬듯이.”\n(We will find a way. We always have.)\n\n사랑은 시공간을 초월하는 유일한 것이에요.',
    '“가장 완벽한 계획이 뭔지 알아? 무계획이야.”\n\n계획을 하면 반드시 계획대로 안 되거든. 인생이 그래.',
    '“세상에서 제일 쓸모없고 해로운 말이 \'그만하면 잘했어(Good job)\'야.”\n\n한계를 뛰어넘는 광기, 그 전율의 순간.',
    '“아빠가 널 끝까지 지켜줄 거란다.”\n\n좀비 바이러스가 창궐한 대한민국, 끝까지 살아남아라.',
  ];

  static final List<String> _moviePosters = [
    'assets/posters/lalaland.jpg',
    'assets/posters/interstellar.jpg',
    'assets/posters/parasite.jpg',
    'assets/posters/whiplash.jpg',
    'assets/posters/train_to_busan.jpg',
  ];

  static final List<String> _movieTitles = [
    'La La Land (2016)',
    'Interstellar (2014)',
    '기생충 (2019)',
    'Whiplash (2014)',
    '부산행 (2016)',
  ];

  // static List로 선언하여 추가/삭제가 가능하도록 함
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
      isFollowed: index % 2 == 0,
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
      text: "Let it go, let it go!",
      source: "Frozen (2013)",
      imageUrl: "assets/posters/frozen.jpg",
    ),
    Quote(
      text: "절대 포기하지 마라.",
      source: "Whiplash",
      imageUrl: "assets/posters/whiplash.jpg",
    ),
    Quote(
      text: "너는 계획이 다 있구나.",
      source: "기생충 (2019)",
      imageUrl: "assets/posters/parasite.jpg",
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
    SceneGroup(
      title: "Must Watch",
      scenes: [
        SceneItem(imageUrl: "assets/posters/lalaland.jpg"),
        SceneItem(imageUrl: "assets/posters/whiplash.jpg"),
        SceneItem(imageUrl: "assets/posters/getout.jpg"),
      ],
    ),
  ];

  static final List<EmotionNote> notes = [
    EmotionNote(
      title: "오늘 '인사이드 아웃'을 보고",
      body: "내 머릿속 감정들도 이렇게 싸우고 있을까? 빙봉이 사라질 때 너무 슬펐다.",
      date: DateTime(2025, 12, 10),
    ),
  ];
}