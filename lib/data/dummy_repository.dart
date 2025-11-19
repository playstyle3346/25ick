import '../models/models.dart';

class DummyRepository {
  // 포스트 데이터
  static final List<Post> posts = List.generate(5, (index) => Post(
    username: '작성자 ${index + 1}',
    userAvatarUrl: 'https://loremflickr.com/100/100/people?random=${index + 10}',
    content: '여기에 게시물 내용이 표시됩니다.',
    imageUrl: 'https://loremflickr.com/600/400/nature?random=$index',
    title: '게시물 제목 ${index + 1}',
  ));

  // 대사 데이터
  static final List<Quote> quotes = [
    Quote(
      text: "개츠비는 그 초록색 불빛을, 우리를 향해 손짓하는 절정의 미래를 믿었습니다.",
      source: "위대한 개츠비 (2013)",
      imageUrl: "https://picsum.photos/id/1015/600/800",
    ),
    Quote(
      text: "후회는 현실에서 또 다른 지옥을 짓는 것이다.",
      source: "신과 함께 (2017)",
      imageUrl: "https://picsum.photos/id/1016/600/800",
    ),
    Quote(
      text: "매너가 사람을 만든다.",
      source: "킹스맨 : 시크릿 에이전트 (2015)",
      imageUrl: "https://picsum.photos/id/1018/600/800",
    ),
  ];

  // 장면 데이터
  static final List<SceneGroup> sceneGroups = [
    SceneGroup(
      title: "중경삼림 (Chungking Express, 1994)",
      scenes: [
        SceneItem(imageUrl: "https://loremflickr.com/600/400/movie?random=1"),
        SceneItem(imageUrl: "https://loremflickr.com/600/400/movie?random=2"),
        SceneItem(imageUrl: "https://loremflickr.com/600/400/movie?random=3"),
      ],
    ),
    SceneGroup(
      title: "라라랜드 (La La Land, 2016)",
      scenes: [
        SceneItem(imageUrl: "https://loremflickr.com/600/400/film?random=4"),
        SceneItem(imageUrl: "https://loremflickr.com/600/400/film?random=5"),
        SceneItem(imageUrl: "https://loremflickr.com/600/400/film?random=6"),
        SceneItem(imageUrl: "https://loremflickr.com/600/400/film?random=7"),
      ],
    ),
  ];

  // 감성노트 초기 데이터
  static final List<EmotionNote> notes = [
    EmotionNote(
      title: "오늘 '애프터썬'을 보고",
      body: "영화가 끝나고 한참을 일어날 수 없었다.",
      date: DateTime(2025, 10, 20),
    ),
  ];
}