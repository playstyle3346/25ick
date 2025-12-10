import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = "http://localhost:8001";

  /// 회원가입
  Future<String?> signup({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "nickname": nickname,
        }),
      );

      if (response.statusCode == 201) {
        return null; // 성공
      }

      return "회원가입 실패: 다시 시도해주세요.";
    } catch (e) {
      return "네트워크 오류가 발생했습니다.";
    }
  }

  /// 🔥 로그인 (User 객체 반환)
  Future<User?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);
      final token = data["access_token"];

      // 토큰 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      // 🔥 유저 정보 요청
      final userData = await getUserData();
      if (userData == null) return null;

      final user = User.fromJson(userData);

      // 프로필 저장
      await saveUserProfile(user);

      return user;
    } catch (e) {
      return null;
    }
  }

  /// 🔥 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    final url = Uri.parse("$baseUrl/auth/me");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  /// 로그아웃
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("nickname");
    await prefs.remove("email");
  }

  /// 자동 로그인 여부
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  /// 🔥 User 객체 저장
  Future<void> saveUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nickname", user.nickname);
    await prefs.setString("email", user.email);

    if (user.profileImage != null) {
      await prefs.setString("profileImage", user.profileImage!);
    }
  }

  /// 저장된 닉네임 가져오기
  Future<String?> getSavedNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("nickname");
  }

  /// 프로필 수정
  Future<String?> updateProfile({
    String? nickname,
    String? about,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return "로그인이 필요합니다.";

    final url = Uri.parse("$baseUrl/auth/update");

    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nickname": nickname,
          "about": about,
        }),
      );

      if (response.statusCode == 200) {
        // 변경사항 다시 불러옴
        final userData = await getUserData();
        if (userData != null) {
          await saveUserProfile(User.fromJson(userData));
        }
        return null;
      }

      return "프로필 수정 실패";
    } catch (e) {
      return "네트워크 오류가 발생했습니다.";
    }
  }
}
