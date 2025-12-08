import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import 'scene_detail_screen.dart';

class SceneArchiveScreen extends StatefulWidget {
  final List<SceneGroup> sceneGroups;
  const SceneArchiveScreen({super.key, required this.sceneGroups});

  @override
  State<SceneArchiveScreen> createState() => _SceneArchiveScreenState();
}

class _SceneArchiveScreenState extends State<SceneArchiveScreen> {
  late List<SceneGroup> _sceneGroups;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _sceneGroups = List.from(widget.sceneGroups);
  }

  /// 이미지 경로 구분
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('assets/')) return AssetImage(path);
    return FileImage(File(path));
  }

  /// 장면 추가
  Future<void> _addScene() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String title = "";

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text("영화 제목 입력",
              style: TextStyle(color: AppColors.textPrimary)),
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
                child: const Text("취소",
                    style: TextStyle(color: AppColors.textSecondary))),
            TextButton(
                onPressed: () => Navigator.pop(context, title),
                child:
                const Text("확인", style: TextStyle(color: AppColors.primary))),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    setState(() {
      _sceneGroups.insert(
        0,
        SceneGroup(
          title: result,
          scenes: [SceneItem(imageUrl: image.path)],
        ),
      );
    });
  }

  /// 장면 삭제
  void _deleteScene(int groupIndex, int sceneIndex) {
    setState(() {
      _sceneGroups[groupIndex].scenes.removeAt(sceneIndex);
      if (_sceneGroups[groupIndex].scenes.isEmpty) {
        _sceneGroups.removeAt(groupIndex);
      }
    });
  }

  /// 삭제 Dialog
  void _showDeleteDialog(int groupIndex, int sceneIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("삭제",
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text("이 장면을 삭제하시겠습니까?",
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소",
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              _deleteScene(groupIndex, sceneIndex);
              Navigator.pop(context);
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("장면 보관함",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addScene,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sceneGroups.length,
        itemBuilder: (context, index) {
          final group = _sceneGroups[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.scenes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, subIndex) {
                    final scene = group.scenes[subIndex];
                    return GestureDetector(
                      onLongPress: () => _showDeleteDialog(index, subIndex),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SceneDetailScreen(imageUrl: scene.imageUrl),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: _getImageProvider(scene.imageUrl),
                          width: 160,
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