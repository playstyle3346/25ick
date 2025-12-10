import 'dart:math';
import '../models/models.dart';

class DummyRepository {
  // ====================================================
  // [핵심 1] 로그인한 유저 정보 & 통계 데이터
  // ====================================================

  static String myName = "Guest";
  static String myProfileImage = "assets/posters/insideout.jpg";
  static int myCommentCount = 0;

  static void setLoggedInUser(String name, String profileImage) {
    myName = name;
    myProfileImage = profileImage;
  }

  static void addPost(Post newPost) {
    posts.insert(0, newPost);
  }

  static void incrementCommentCount() {
    myCommentCount++;
  }

  // ====================================================
  // [랜덤 닉네임 리스트 추가 💬]
  // ====================================================
  static final List<String> randomNicknames = [
    "시네필로",
    "무비덕후",
    "감성파 고양이",
    "팝콘요정",
    "필름러버",
    "밤하늘별빛",
    "라라랜드러버",
    "스릴러광",
    "영화광인간",
    "드라마퀸",
    "감정폭발러",
    "시간여행자",
    "필름소울",
    "유니버스러버",
    "무비홀릭",
  ];

  static String getRandomNickname() {
    final rand = Random();
    return randomNicknames[rand.nextInt(randomNicknames.length)];
  }

  // ====================================================
  // [기존 더미 데이터]
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

  // ✅ 랜덤 닉네임 + 랜덤 프로필이미지 적용
  static List<Post> posts = List.generate(5, (index) {
    final nickname = getRandomNickname();
    final avatarList = [
      'assets/posters/insideout.jpg',
      'assets/posters/getout.jpg',
      'assets/posters/avengers.jpg',
      'assets/posters/interstellar.jpg',
      'assets/posters/parasite.jpg',
    ];
    final avatar = avatarList[Random().nextInt(avatarList.length)];

    return Post(
      username: nickname,
      userAvatarUrl: avatar,
      title: _movieTitles[index],
      content: _postContents[index],
      imageUrl: _moviePosters[index],
      likes: 0,
      dislikes: 0,
      comments: [],
      createdAt: DateTime.now().subtract(Duration(hours: index * 5)),
      isFollowed: index.isEven,
      isLiked: false,
      isDisliked: false,
    );
  });

  // ====================================================
  // 나머지 더미 데이터 동일
  // ====================================================
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
