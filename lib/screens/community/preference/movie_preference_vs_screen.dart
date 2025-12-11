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

  /// 현재 라운드에 남아 있는 후보들
  late List<String> _currentCandidates;

  /// 다음 라운드로 진출할 승자들
  List<String> _nextRoundCandidates = [];

  /// 현재 라운드에서 몇 번째 매치업인지 (0부터 시작)
  int _currentPairIndex = 0;

  /// 라운드 수 (1라운드, 2라운드, …)
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

  /// 🔥 영화 선택 시 호출 (VS에서 하나 고를 때마다)
  void _selectMovie(String chosenMovie) {
    // 1) 태그 점수 누적 (취향 분석용)
    MovieAlgorithm.addScore(chosenMovie);

    // 2) 선택된 영화는 다음 라운드 후보에 추가
    _nextRoundCandidates.add(chosenMovie);

    final int totalPairs = _totalPairsThisRound;
    final bool isLastPair = _currentPairIndex + 1 >= totalPairs;

    if (isLastPair) {
      // ✅ 현재 라운드가 끝나는 순간

      // 현재 라운드의 후보 수가 홀수였다면 → 마지막 1명 부전승 자동 진출
      if (_currentCandidates.length.isOdd) {
        final lastIndex = _currentCandidates.length - 1;
        final byeMovie = _currentCandidates[lastIndex];
        _nextRoundCandidates.add(byeMovie);
      }

      // ✅ 이제 다음 라운드로 갈 사람들(_nextRoundCandidates)이 정해졌다.

      // 1) 만약 최종 1명만 남았으면 → 결과 화면으로 이동
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

      // 2) 아직 후보가 여러 명이면 → 다음 라운드를 위해 상태 업데이트
      setState(() {
        _currentCandidates = List.from(_nextRoundCandidates);
        _nextRoundCandidates = [];
        _currentPairIndex = 0;
        _currentRound++;
      });
    } else {
      // 아직 이번 라운드의 매치업이 남았다면 → 다음 매치로 이동
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

    // 현재 VS에 표시할 두 영화
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

          /// 🔥 진행 바 (이번 라운드 기준)
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
                : "Round $_currentRound\n더 끌리는 영화를 선택하면, 마지막에 단 한 편만 남게 돼요.",
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
                  "다음 라운드를 준비 중입니다...",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),

          const Spacer(),
        ],
      ),
    );
  }

  /// 🔥 개별 영화 선택 카드 (포스터 + 제목 + 선택 버튼)
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



// // lib/screens/movie_preference_vs_screen.dart
//
// import 'package:flutter/material.dart';
// import '../../../theme/app_colors.dart';
// import 'movie_preference_result_screen.dart';
// import '../../../services/movie_algorithm.dart';
//
// class MoviePreferenceVsScreen extends StatefulWidget {
//   final bool reset;
//
//   const MoviePreferenceVsScreen({
//     super.key,
//     this.reset = false,
//   });
//
//   @override
//   State<MoviePreferenceVsScreen> createState() =>
//       _MoviePreferenceVsScreenState();
// }
//
// class _MoviePreferenceVsScreenState extends State<MoviePreferenceVsScreen> {
//   int _currentStep = 0;
//
//   /// 🔥 장르 균형을 맞춘 5개 VS 매칭
//   final List<Map<String, String>> _matchups = [
//     {"left": "라라랜드", "right": "어벤져스: 엔드게임"},
//     {"left": "인사이드 아웃", "right": "겟 아웃"},
//     {"left": "포레스트 검프", "right": "기생충"},
//     {"left": "인터스텔라", "right": "위플래시"},
//     {"left": "겨울왕국", "right": "부산행"},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // VS 시작할 때 알고리즘 상태 초기화
//     MovieAlgorithm.reset();
//
//     if (widget.reset) {
//       _currentStep = 0;
//     }
//   }
//
//   /// 🔥 영화 선택 시 호출
//   void _selectMovie(String chosenMovie) {
//     // 1) 장르 점수 누적
//     MovieAlgorithm.addScore(chosenMovie);
//
//     // 2) 다음 스텝으로
//     setState(() => _currentStep++);
//
//     // 3) 5개 선택 완료 → 취향 유형 계산 후 결과 페이지 이동
//     if (_currentStep >= _matchups.length) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         final type = MovieAlgorithm.determineUserType();
//         final rec = MovieAlgorithm.recommendations[type] ?? [];
//
//         MovieAlgorithm.lastUserType = type;
//         MovieAlgorithm.lastRecommendations = rec;
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const MoviePreferenceResultScreen(),
//           ),
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isFinished = _currentStep >= _matchups.length;
//     final Map<String, String>? current =
//     isFinished ? null : _matchups[_currentStep];
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Icon(Icons.close, color: Colors.white),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//
//           /// 🔥 진행 바
//           Container(
//             height: 3,
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width *
//                 ((_currentStep.clamp(0, _matchups.length)) / _matchups.length),
//             color: AppColors.primary,
//           ),
//
//           const SizedBox(height: 24),
//
//           const Text(
//             "영화 취향에 맞춰 5번 골라주세요.\n더 끌리는 영화를 선택하면, 당신의 유형을 분석해 드려요.",
//             style: TextStyle(color: Colors.white70),
//             textAlign: TextAlign.center,
//           ),
//
//           const SizedBox(height: 60),
//
//           /// 영화 선택 VS 구성
//           if (!isFinished && current != null)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _movieChoice(current["left"]!),
//                 const Text(
//                   "VS",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 _movieChoice(current["right"]!),
//               ],
//             ),
//
//           const Spacer(),
//
//           /// 🔥 5개 끝나면 "모든 평가 완료" 표시
//           if (isFinished)
//             const Padding(
//               padding: EdgeInsets.only(bottom: 20),
//               child: Text(
//                 "모든 평가가 완료되었습니다.\n결과 화면으로 이동 중...",
//                 style: TextStyle(color: Colors.white54),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔥 개별 선택 버튼 (포스터 포함)
//   Widget _movieChoice(String title) {
//     final poster = MovieAlgorithm.posterPaths[title];
//
//     return Column(
//       children: [
//
//         /// 🔥 영화 포스터
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Image.asset(
//             poster ?? "assets/placeholder.jpg",
//             width: 200,
//             height: 250,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         /// 🔥 제목
//         SizedBox(
//           width: 120,
//           child: Text(
//             title,
//             style: const TextStyle(color: Colors.white70),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         /// 🔥 선택 버튼
//         InkWell(
//           onTap: () => _selectMovie(title),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColors.primary, width: 1.4),
//             ),
//             child: const Text(
//               "선택",
//               style: TextStyle(
//                 color: AppColors.primary,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
// }