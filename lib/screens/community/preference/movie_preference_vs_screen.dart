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
  /// 🔥 초기 10개 후보 리스트
  final List<String> _initialMovies = [
    "라라랜드",
    "어벤져스: 엔드게임",
    "인사이드 아웃",
    "겟 아웃",
    "포레스트 검프",
    "기생충",
    "인터스텔라",
    "위플래시",
    "겨울왕국",
    "부산행",
  ];

  /// 현재 라운드의 후보자들
  late List<String> _currentCandidates;

  /// 다음 라운드 후보들
  List<String> _nextRoundCandidates = [];

  /// 현재 라운드의 페어 인덱스
  int _currentPairIndex = 0;

  /// 현재 라운드 번호
  int _currentRound = 1;

  int get _totalPairsThisRound => _currentCandidates.length ~/ 2;

  @override
  void initState() {
    super.initState();

    MovieAlgorithm.reset();

    _currentCandidates = List.from(_initialMovies);
    _nextRoundCandidates = [];
    _currentPairIndex = 0;
    _currentRound = 1;
  }

  /// 🔥 영화 선택 시 호출
  void _selectMovie(String chosenMovie) {
    // 선택된 영화 → 다음 라운드 후보로
    MovieAlgorithm.addScore(chosenMovie);
    _nextRoundCandidates.add(chosenMovie);

    final int totalPairs = _totalPairsThisRound;
    final bool isLastPair = _currentPairIndex + 1 >= totalPairs;

    if (isLastPair) {
      // 라운드 마지막 매치

      // 홀수면 마지막 1명 부전승 처리
      if (_currentCandidates.length.isOdd) {
        final byeMovie = _currentCandidates.last;
        _nextRoundCandidates.add(byeMovie);
      }

      // 최종 1명만 남았으면 결과 화면으로 이동
      if (_nextRoundCandidates.length == 1) {
        final winner = _nextRoundCandidates.first;
        MovieAlgorithm.finalizeResult(winner);

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MoviePreferenceResultScreen(),
            ),
          );
        });
        return;
      }

      // 다음 라운드로 업데이트
      setState(() {
        _currentCandidates = List.from(_nextRoundCandidates);
        _nextRoundCandidates = [];
        _currentPairIndex = 0;
        _currentRound++;
      });
    } else {
      setState(() {
        _currentPairIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final bool isFinalRound = _currentCandidates.length == 2;
    final int totalPairs = _totalPairsThisRound;

    String? leftTitle;
    String? rightTitle;

    if (totalPairs > 0 && _currentPairIndex < totalPairs) {
      final int leftIndex = _currentPairIndex * 2;
      final int rightIndex = leftIndex + 1;

      leftTitle = _currentCandidates[leftIndex];
      rightTitle = _currentCandidates[rightIndex];
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // ❌ X 버튼 제거됨 (actions 없음)
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔥 진행 바
          Container(
            height: 3,
            width: totalPairs == 0
                ? 0
                : width * ((_currentPairIndex + 1) / totalPairs),
            color: AppColors.primary,
          ),

          const SizedBox(height: 16),

          Text(
            isFinalRound
                ? "마지막 선택이에요.\n더 마음에 드는 영화를 골라주세요."
                : "Round $_currentRound\n더 끌리는 영화를 선택하면 마지막에 단 한 편이 남아요.",
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          if (leftTitle != null && rightTitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _movieChoice(leftTitle),
                const Text(
                  "VS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _movieChoice(rightTitle),
              ],
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  "다음 라운드를 준비 중...",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),

          const Spacer(),
        ],
      ),
    );
  }

  /// 🔥 영화 선택 UI
  Widget _movieChoice(String title) {
    final poster = MovieAlgorithm.posterPaths[title];

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            poster ?? "assets/placeholder.jpg",
            width: 180,
            height: 240,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 140,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),

        InkWell(
          onTap: () => _selectMovie(title),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
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
