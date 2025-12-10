import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class SceneDetailScreen extends StatelessWidget {
  final SceneItem scene;

  const SceneDetailScreen({
    super.key,
    required this.scene,
  });

  ImageProvider _buildImage() {
    if (scene.imageBytes != null) {
      return MemoryImage(scene.imageBytes!);
    }
    if (scene.imageUrl != null && scene.imageUrl!.isNotEmpty) {
      return AssetImage(scene.imageUrl!);
    }
    return const AssetImage('assets/placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image(
                  image: _buildImage(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
