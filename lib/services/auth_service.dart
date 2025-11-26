class AuthService {
  static bool isLoggedIn = false;
  static String? userEmail;

  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email == "test@talkie.com" && password == "1234") {
      isLoggedIn = true;
      userEmail = email;
      return true;
    }
    return false;
  }

  static void logout() {
    isLoggedIn = false;
    userEmail = null;
  }
}
