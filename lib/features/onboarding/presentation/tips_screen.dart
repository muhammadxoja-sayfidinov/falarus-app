import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/glass_container.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Get translations
    final l10n = AppLocalizations.of(context)!;

    // Update tips with localized strings
    final tips = [
      {
        'icon': Icons.school_outlined,
        'title': l10n.tip1Title,
        'description': l10n.tip1Desc,
      },
      {
        'icon': Icons.show_chart_rounded,
        'title': l10n.tip2Title,
        'description': l10n.tip2Desc,
      },
      {
        'icon': Icons.verified_user_outlined,
        'title': l10n.tip3Title,
        'description': l10n.tip3Desc,
      },
    ];

    return BackgroundScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlassContainer(
                          padding: const EdgeInsets.all(40),
                          borderRadius: BorderRadius.circular(100),
                          color: AppTheme.mondeluxAccent,
                          fillOpacity: 0.2,
                          child: Icon(
                            tip['icon'] as IconData,
                            size: 80,
                            color: AppTheme.mondeluxPrimary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          tip['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tip['description'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators and Button
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      tips.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.mondeluxPrimary
                              : AppTheme.mondeluxPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get Started Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < tips.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.mondeluxPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        splashFactory: NoSplash.splashFactory,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == tips.length - 1
                            ? l10n.getStarted
                            : l10n.next,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
