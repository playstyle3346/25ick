import '../models/models.dart';

class DummyRepository {
  // 기본 placeholder 이미지 (assets에 반드시 추가해야 함)
  static const String placeholder = "assets/posters/lalaland.jpg";

  // 포스트 데이터 (모두 AssetImage로 변경)
  static final List<Post> posts = List.generate(
    5,
        (index) => Post(
      username: '작성자 ${index + 1}',
      userAvatarUrl: placeholder,
      content: '여기에 게시물 내용이 표시됩니다.',
      imageUrl: placeholder,
      title: '게시물 제목 ${index + 1}',
    ),
  );

  // 대사 데이터 (picsum → asset)
  static final List<Quote> quotes = [
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

  // 장면 데이터 (모두 asset)
  static final List<SceneGroup> sceneGroups = [
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

  // 감성노트 (이미 정상)
  static final List<EmotionNote> notes = [
    EmotionNote(
      title: "오늘 '애프터썬'을 보고",
      body: "영화가 끝나고 한참을 일어날 수 없었다.",
      date: DateTime(2025, 10, 20),
    ),
  ];
}
