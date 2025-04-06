import 'package:flutter/material.dart';
import 'package:my_ui/features/auth/presentation/cubits/pages/login_page.dart';
import 'package:my_ui/features/auth/presentation/cubits/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showlodingPage = true;
  void togglePagess() {
    setState(() {
      showlodingPage = !showlodingPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showlodingPage) {
      return LoginPage(
        tooglepages: togglePagess,
      );
    } else {
      return RegisterPage(
        tooglepages: togglePagess,
      );
    }
  }
}
