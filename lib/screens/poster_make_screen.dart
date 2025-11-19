import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PosterMakeScreen extends StatefulWidget {
  const PosterMakeScreen({super.key});

  @override
  State<PosterMakeScreen> createState() => _PosterMakeScreenState();
}

class _PosterMakeScreenState extends State<PosterMakeScreen> {
  String? selectedPoster;
  final TextEditingController _textController = TextEditingController();

  final List<String> posters = [
    "assets/posters/poster1.jpg",
    "assets/posters/poster2.jpg",
    "assets/posters/poster3.jpg",
    "assets/posters/poster4.jpg",
    "assets/posters/poster5.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("포스터 만들기", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "포스터를 선택하세요",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posters.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final img = posters[index];
                final isSelected = selectedPoster == img;

                return InkWell(
                  onTap: () {
                    setState(() => selectedPoster = img);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 3,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.check,
                                color: AppColors.primary, size: 40),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "포스터 문구 입력",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _textController,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "포스터에 들어갈 문구",
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: InkWell(
                onTap: () {
                  if (selectedPoster == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("포스터를 선택해주세요."),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PosterPreviewScreen(
                        posterPath: selectedPoster!,
                        text: _textController.text,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "미리보기",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 🔥 미리보기 화면
class PosterPreviewScreen extends StatelessWidget {
  final String posterPath;
  final String text;

  const PosterPreviewScreen({
    super.key,
    required this.posterPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              posterPath,
              width: 300,
              fit: BoxFit.cover,
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.all(12),
              color: Colors.black.withOpacity(0.6),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
