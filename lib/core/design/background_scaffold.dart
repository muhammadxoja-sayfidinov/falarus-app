import 'package:flutter/material.dart';

import 'app_theme.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const BackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Simple subtle green gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.mondeluxSurfaceSecond, // Light mint
                AppTheme.mondeluxBackground, // Very light mint
              ],
            ),
          ),
        ),

        // Subtle decorative orb - top right
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.mondeluxAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Subtle decorative orb - bottom left
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.mondeluxPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Removed global blur for a sharper look

        // Main Content
        Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.transparent,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          body: SafeArea(child: body),
        ),
      ],
    );
  }
}
