import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static const String baseUrl = "http://localhost:8000";

  // 🔹 게시글 목록 조회
  Future<List<dynamic>> fetchPosts() async {
    final url = Uri.parse("$baseUrl/posts/list");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 🔹 게시글 상세 조회
  Future<Map<String, dynamic>?> fetchPostDetail(int postId) async {
    final url = Uri.parse("$baseUrl/posts/$postId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 🔹 게시글 작성
  Future<String?> createPost(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return "로그인이 필요합니다.";

    final url = Uri.parse("$baseUrl/posts/create");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "content": content,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // 성공
      }

      return "게시글 작성 실패 (${response.statusCode})";
    } catch (e) {
      return "네트워크 오류가 발생했습니다.";
    }
  }
}
