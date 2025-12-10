import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import '../models/models.dart';
import 'scene_detail_screen.dart';

class SceneArchiveScreen extends StatefulWidget {
  final List<SceneGroup> sceneGroups;

  const SceneArchiveScreen({
    super.key,
    required this.sceneGroups,
  });

  @override
  State<SceneArchiveScreen> createState() => _SceneArchiveScreenState();
}

class _SceneArchiveScreenState extends State<SceneArchiveScreen> {
  late List<SceneGroup> _sceneGroups;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 기존 더미 데이터(에셋 기반) 복사
    _sceneGroups = List.from(widget.sceneGroups);
  }

  /// ------------------------------------------------------------
  /// SceneItem → ImageProvider
  /// 1) imageBytes 있으면 메모리 이미지
  /// 2) imageUrl(assets/...) 있으면 에셋
  /// 3) 둘 다 없으면 placeholder
  /// ------------------------------------------------------------
  ImageProvider _buildImage(SceneItem item) {
    if (item.imageBytes != null) {
      return MemoryImage(item.imageBytes!);
    }
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return AssetImage(item.imageUrl!);
    }
    return const AssetImage('assets/placeholder.png'); // 네가 말한 위치
  }

  /// ------------------------------------------------------------
  /// + 버튼 → 새 그룹 + 첫 장면 업로드
  /// ------------------------------------------------------------
  Future<void> _addSceneGroup() async {
    // 웹/모바일 모두 지원 (image_picker 사용)
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();

    String title = "";

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          "영화 제목 입력",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: "예: 라라랜드",
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
          onChanged: (v) => title = v,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "취소",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, title.trim()),
            child: const Text(
              "확인",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    setState(() {
      _sceneGroups.insert(
        0,
        SceneGroup(
          title: result,
          scenes: [
            SceneItem(imageBytes: bytes), // ✅ 업로드 이미지로 새 씬
          ],
        ),
      );
    });
  }

  /// ------------------------------------------------------------
  /// 장면 삭제
  /// ------------------------------------------------------------
  void _confirmDelete(int groupIndex, int itemIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          "삭제",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          "이 장면을 삭제하시겠습니까?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "취소",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _sceneGroups[groupIndex].scenes.removeAt(itemIndex);
                if (_sceneGroups[groupIndex].scenes.isEmpty) {
                  _sceneGroups.removeAt(groupIndex);
                }
              });
              Navigator.pop(context);
            },
            child: const Text(
              "삭제",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// UI
  /// ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          "장면 보관함",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSceneGroup,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sceneGroups.length,
        itemBuilder: (context, groupIndex) {
          final group = _sceneGroups[groupIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 제목 (Best Movies, Must Watch, 새로 만든 제목 등)
              Text(
                group.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // 해당 그룹의 씬들 (여러 장 유지)
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.scenes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, itemIndex) {
                    final scene = group.scenes[itemIndex];

                    return GestureDetector(
                      onLongPress: () =>
                          _confirmDelete(groupIndex, itemIndex),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SceneDetailScreen(scene: scene),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: _buildImage(scene),
                          width: 150,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
