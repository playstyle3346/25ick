import '../models/models.dart';

class DummyRepository {
  // -------------------------------
  // Placeholder 이미지
  // -------------------------------
  static const String placeholder = "assets/posters/lalaland.jpg";

  // -------------------------------
  // 명대사 텍스트 (본문)
  // -------------------------------
  static final List<String> _postContents = [
    '“사람들은 다른 사람의 열정에 끌리게 되어있어.\n자신이 잊은 걸 상기시켜 주니까.”\n\n꿈을 꾸는 사람들을 위한 별들의 도시, 라라랜드.',
    '“우린 답을 찾을 것이다. 늘 그랬듯이.”\n(We will find a way. We always have.)\n\n사랑은 시공간을 초월하는 유일한 것이에요.',
    '“가장 완벽한 계획이 뭔지 알아? 무계획이야.”\n\n계획을 하면 반드시 계획대로 안 되거든. 인생이 그래.',
    '“세상에서 제일 쓸모없고 해로운 말이 \'그만하면 잘했어(Good job)\'야.”\n\n한계를 뛰어넘는 광기, 그 전율의 순간.',
    '“어떤 사람을 위해서라면 녹아도 좋아.”\n(Some people are worth melting for.)\n\n진정한 사랑은 다른 사람을 더 먼저 생각하는 거야.',
  ];

  // -------------------------------
  // 포스터 이미지
  // -------------------------------
  static final List<String> _moviePosters = [
    'assets/posters/lalaland.jpg',
    'assets/posters/interstellar.jpg',
    'assets/posters/parasite.jpg',
    'assets/posters/whiplash.jpg',
    'assets/posters/frozen.jpg',
  ];

  // -------------------------------
  // 영화 제목
  // -------------------------------
  static final List<String> _movieTitles = [
    'La La Land (2016)',
    'Interstellar (2014)',
    '기생충 (2019)',
    'Whiplash (2014)',
    'Frozen (2013)',
  ];

  // -------------------------------
  // 포스트(Post) 더미 데이터
  // -------------------------------
  static final List<Post> posts = List.generate(5, (index) {
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

  // -------------------------------
  // 대사 보관함 (Quote)
  // -------------------------------
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
      text: "개츠비는 그 초록색 불빛을 믿었습니다.",
      source: "위대한 개츠비 (2013)",
      imageUrl: placeholder,
    ),
    Quote(
      text: "후회는 현실에서 또 다른 지옥을 짓는 것이다.",
      source: "신과 함께 (2017)",
      imageUrl: placeholder,
    ),
    Quote(
      text: "매너가 사람을 만든다.",
      source: "킹스맨 (2015)",
      imageUrl: placeholder,
    ),
  ];

  // -------------------------------
  // 장면(SceneGroup)
  // -------------------------------
  static final List<SceneGroup> sceneGroups = [
    SceneGroup(
      title: "SF 명작",
      scenes: [
        SceneItem(imageUrl: "assets/posters/interstellar.jpg"),
        SceneItem(imageUrl: "assets/posters/avengers.jpg"),
      ],
    ),
    SceneGroup(
      title: "중경삼림 (1994)",
      scenes: [
        SceneItem(imageUrl: placeholder),
        SceneItem(imageUrl: placeholder),
        SceneItem(imageUrl: placeholder),
      ],
    ),
    SceneGroup(
      title: "라라랜드 (2016)",
      scenes: [
        SceneItem(imageUrl: placeholder),
        SceneItem(imageUrl: placeholder),
        SceneItem(imageUrl: placeholder),
        SceneItem(imageUrl: placeholder),
      ],
    ),
  ];

  // -------------------------------
  // 감성노트 (EmotionNote)
  // -------------------------------
  static final List<EmotionNote> notes = [
    EmotionNote(
      title: "오늘 '애프터썬'을 보고",
      body: "영화가 끝나고 한참을 일어날 수 없었다.",
      date: DateTime(2025, 10, 20),
    ),
  ];
}
