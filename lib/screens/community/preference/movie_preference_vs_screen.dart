// lib/screens/movie_preference_vs_screen.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'movie_preference_result_screen.dart';
import '../../../services/movie_algorithm.dart';

class MoviePreferenceVsScreen extends StatefulWidget {
  final bool reset;

  const MoviePreferenceVsScreen({
    super.key,
    this.reset = false,
  });

  @override
  State<MoviePreferenceVsScreen> createState() =>
      _MoviePreferenceVsScreenState();
}

class _MoviePreferenceVsScreenState extends State<MoviePreferenceVsScreen> {
  int _currentStep = 0;

  /// 🔥 장르 균형을 맞춘 5개 VS 매칭
  final List<Map<String, String>> _matchups = [
    {"left": "라라랜드", "right": "어벤져스: 엔드게임"},
    {"left": "인사이드 아웃", "right": "겟 아웃"},
    {"left": "포레스트 검프", "right": "기생충"},
    {"left": "인터스텔라", "right": "위플래시"},
    {"left": "겨울왕국", "right": "부산행"},
  ];

  @override
  void initState() {
    super.initState();

    // VS 시작할 때 알고리즘 상태 초기화
    MovieAlgorithm.reset();

    if (widget.reset) {
      _currentStep = 0;
    }
  }

  /// 🔥 영화 선택 시 호출
  void _selectMovie(String chosenMovie) {
    // 1) 장르 점수 누적
    MovieAlgorithm.addScore(chosenMovie);

    // 2) 다음 스텝으로
    setState(() => _currentStep++);

    // 3) 5개 선택 완료 → 취향 유형 계산 후 결과 페이지 이동
    if (_currentStep >= _matchups.length) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final type = MovieAlgorithm.determineUserType();
        final rec = MovieAlgorithm.recommendations[type] ?? [];

        MovieAlgorithm.lastUserType = type;
        MovieAlgorithm.lastRecommendations = rec;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MoviePreferenceResultScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _currentStep >= _matchups.length;
    final Map<String, String>? current =
    isFinished ? null : _matchups[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.close, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔥 진행 바
          Container(
            height: 3,
            width: MediaQuery
                .of(context)
                .size
                .width *
                ((_currentStep.clamp(0, _matchups.length)) / _matchups.length),
            color: AppColors.primary,
          ),

          const SizedBox(height: 24),

          const Text(
            "영화 취향에 맞춰 5번 골라주세요.\n더 끌리는 영화를 선택하면, 당신의 유형을 분석해 드려요.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 60),

          /// 영화 선택 VS 구성
          if (!isFinished && current != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _movieChoice(current["left"]!),
                const Text(
                  "VS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _movieChoice(current["right"]!),
              ],
            ),

          const Spacer(),

          /// 🔥 5개 끝나면 "모든 평가 완료" 표시
          if (isFinished)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "모든 평가가 완료되었습니다.\n결과 화면으로 이동 중...",
                style: TextStyle(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  /// 🔥 개별 선택 버튼 (포스터 포함)
  Widget _movieChoice(String title) {
    final poster = MovieAlgorithm.posterPaths[title];

    return Column(
      children: [

        /// 🔥 영화 포스터
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            poster ?? "assets/placeholder.jpg",
            width: 200,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),

        /// 🔥 제목
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),

        /// 🔥 선택 버튼
        InkWell(
          onTap: () => _selectMovie(title),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 1.4),
            ),
            child: const Text(
              "선택",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

}