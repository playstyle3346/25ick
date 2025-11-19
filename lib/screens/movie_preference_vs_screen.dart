import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'movie_preference_result_screen.dart';

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

  final List<Map<String, String>> _matchups = [
    {"left": "REBEL MOON", "right": "블레이드러너"},
    {"left": "A.I.", "right": "에이리언: 커버넌트"},
    {"left": "인터스텔라", "right": "그래비티"},
    {"left": "트론", "right": "에일리언"},
    {"left": "메트릭스", "right": "블레이드러너 2049"},
  ];

  @override
  void initState() {
    super.initState();

    // 🔥 reset=true 상태로 진입하면 처음부터 선택 가능
    if (widget.reset) {
      _currentStep = 0;
    }
  }

  void _selectMovie() {
    setState(() => _currentStep++);

    // 🔥 5개 선택 완료 → 결과 페이지로 이동
    if (_currentStep >= _matchups.length) {
      Future.delayed(const Duration(milliseconds: 300), () {
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
    // 끝까지 왔다면 더 이상 목록 꺼내지 않음
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
          onPressed: () => Navigator.pop(context), // 오류 없음
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
            width: MediaQuery.of(context).size.width *
                ((_currentStep.clamp(0, _matchups.length)) / _matchups.length),
            color: AppColors.primary,
          ),

          const SizedBox(height: 24),

          const Text(
            "영화 취향에 맞춰 5점을 남겨보세요.\n이런 영화를 좋아하신다면, 당신의 취향을 골라주세요.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 60),

          /// 영화 선택 vs 구성
          if (!isFinished)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _movieChoice(current!["left"]!),
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
                "모든 평가가 완료되었습니다.",
                style: TextStyle(color: Colors.white54),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔥 개별 선택 버튼
  Widget _movieChoice(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectMovie,
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
        )
      ],
    );
  }
}
