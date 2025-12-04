import '../models/models.dart';

class DummyRepository {
  // ✨ 1. 영화별 실제 명대사 (본문용)
  static final List<String> _postContents = [
    // 라라랜드
    '“사람들은 다른 사람의 열정에 끌리게 되어있어.\n자신이 잊은 걸 상기시켜 주니까.”\n\n꿈을 꾸는 사람들을 위한 별들의 도시, 라라랜드.',

    // 인터스텔라
    '“우린 답을 찾을 것이다. 늘 그랬듯이.”\n(We will find a way. We always have.)\n\n사랑은 시공간을 초월하는 유일한 것이에요.',

    // 기생충
    '“가장 완벽한 계획이 뭔지 알아? 무계획이야.”\n\n계획을 하면 반드시 계획대로 안 되거든. 인생이 그래.',

    // 위플래쉬
    '“세상에서 제일 쓸모없고 해로운 말이 \'그만하면 잘했어(Good job)\'야.”\n\n한계를 뛰어넘는 광기, 그 전율의 순간.',

    // 겨울왕국
    '“어떤 사람을 위해서라면 녹아도 좋아.”\n(Some people are worth melting for.)\n\n진정한 사랑 행동은 다른 사람을 나보다 더 먼저 생각하는 거야.'
  ];

  // ✨ 2. 영화 포스터 파일명 (assets/posters/ 폴더 기준)
  static final List<String> _moviePosters = [
    'assets/posters/lalaland.jpg',
    'assets/posters/interstellar.jpg',
    'assets/posters/parasite.jpg',
    'assets/posters/whiplash.jpg',
    'assets/posters/frozen.jpg',
  ];

  // ✨ 3. 영화 제목
  static final List<String> _movieTitles = [
    'La La Land (2016)',
    'Interstellar (2014)',
    '기생충 (2019)',
    'Whiplash (2014)',
    'Frozen (2013)',
  ];

  // ✨ 4. 포스트 데이터 생성 (위의 데이터들을 순서대로 매칭)
  static final List<Post> posts = List.generate(5, (index) => Post(
    username: 'MovieFan ${index + 1}',
    // 프로필 이미지는 임시로 '인사이드 아웃'이나 '겟아웃' 사용
    userAvatarUrl: index % 2 == 0
        ? 'assets/posters/insideout.jpg'
        : 'assets/posters/getout.jpg',

    // 본문 내용 (명대사)
    content: _postContents[index % _postContents.length],

    // 포스터 이미지
    imageUrl: _moviePosters[index % _moviePosters.length],

    // 영화 제목
    title: _movieTitles[index % _movieTitles.length],

    // [인기순 정렬 테스트용] 좋아요 수 랜덤 설정
    likes: 0,

    // [최신순 정렬 테스트용] 작성 시간 (0, 5, 10... 시간 전)
    createdAt: DateTime.now().subtract(Duration(hours: index * 5)),

    // [팔로우 탭 테스트용] 짝수 인덱스만 팔로우 중
    isFollowed: index % 2 == 0,

    dislikes: 0,
  ));

  // ✨ 대사 보관함 데이터 (초기화)
  // 사용자가 직접 추가하는 것을 테스트하기 위해 비워두거나, 아래처럼 예시를 넣을 수 있습니다.
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
  ];

  // ✨ 장면 보관함 데이터 (초기화)
  static final List<SceneGroup> sceneGroups = [
    SceneGroup(
      title: "SF 명작",
      scenes: [
        SceneItem(imageUrl: "assets/posters/interstellar.jpg"),
        SceneItem(imageUrl: "assets/posters/avengers.jpg"),
      ],
    ),
  ];

  // ✨ 감성노트 데이터 (초기화)
  static final List<EmotionNote> notes = [];
}