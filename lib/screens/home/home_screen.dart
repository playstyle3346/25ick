import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/section_title.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/genre_chip.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nickname = "시네프렌양님"; // 기본 닉네임
  final Random _random = Random();

  // 🔹 사용할 로컬 포스터 목록
  final List<String> posterPaths = [
    "assets/posters/aftersun.jpg",
    "assets/posters/lalaland.jpg",
    "assets/posters/inception.jpg",
    "assets/posters/whiplash.jpg",
    "assets/posters/interstellar.jpg",
    "assets/posters/parasite.jpg",
    "assets/posters/soul.jpg",
    "assets/posters/spiderman.jpg",
    "assets/posters/yourname.jpg",
    "assets/posters/default.jpg",
    "assets/posters/reze.jpg",
    "assets/posters/kaguyahime.jpg",
    "assets/posters/nowyouseeme.jpg",
    "assets/posters/zootopia.jpg",
    "assets/posters/wicked.jpg"
  ];

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final saved = await AuthService().getSavedNickname();
    setState(() {
      if (saved != null && saved.isNotEmpty) {
        nickname = saved;
      }
    });
  }

  // 🔹 랜덤 포스터 1장 선택
  String getRandomPoster() {
    return posterPaths[_random.nextInt(posterPaths.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "안녕하세요, $nickname",
          style: const TextStyle(fontSize: 20, color: AppColors.textPrimary),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎬 ① 대표 배너 (랜덤 포스터)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    getRandomPoster(),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "오늘의 추천 영화",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "감성을 자극하는 한 장면",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 ② 실시간 HOT 인기작
            const SectionTitle(title: "실시간 HOT 인기작"),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  final image = getRandomPoster();
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.asset(
                            image,
                            width: 120,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 120,
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Text(
                              "인기 영화 ${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 🎭 ③ 취향 찾기
            const SectionTitle(title: "인기 장르"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                GenreChip(label: "SF"),
                GenreChip(label: "로맨스"),
                GenreChip(label: "애니메이션"),
                GenreChip(label: "스릴러"),
                GenreChip(label: "액션"),
                GenreChip(label: "드라마"),
              ],
            ),

            const SizedBox(height: 24),

            // 🏆 ④ 최신 TOP
            const SectionTitle(title: "최신 TOP"),
            const SizedBox(height: 8),
            Column(
              children: List.generate(
                3,
                    (index) {
                  final image = getRandomPoster();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "TOP ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
