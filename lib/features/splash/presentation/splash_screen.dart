import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/app_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (FirebaseAuth.instance.currentUser != null) {
        context.go('/home');
      } else {
        context.go('/language');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppTheme.mondeluxPrimary),
          ],
        ),
      ),
    );
  }
}
