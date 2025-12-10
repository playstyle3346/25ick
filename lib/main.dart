import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/main_layout.dart';

// Theme
import 'theme/app_colors.dart';

// Global AppState
import 'state/app_state.dart';
import 'data/dummy_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 기존 DummyRepository 데이터를 AppState에 로드
  AppState().posts = DummyRepository.posts;

  runApp(const TalkieApp());
}

class TalkieApp extends StatelessWidget {
  const TalkieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talkie',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 로그인 여부 확인 (SharedPreferences)
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    setState(() {
      _loggedIn = token != null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 로그인되어 있으면 MainLayout, 아니면 LoginScreen
    return _loggedIn ? const MainLayout() : const LoginScreen();
  }
}