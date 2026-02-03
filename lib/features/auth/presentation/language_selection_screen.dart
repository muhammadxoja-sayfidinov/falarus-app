import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/glass_container.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/design/app_theme.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackgroundScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/logo.png', width: 120, height: 120),
              const SizedBox(height: 32),

              // Title
              Text(
                "Tilni tanlang",
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mondeluxPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                "Select Language / Выберите язык",
                style: GoogleFonts.outfit(
                  color: AppTheme.mondeluxPrimary.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),

              // Vertical List
              Column(
                children: [
                  _buildLanguageCard(
                    context,
                    ref,
                    "O'zbek",
                    const Locale('uz'),
                    '🇺🇿',
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageCard(
                    context,
                    ref,
                    'Русский',
                    const Locale('ru'),
                    '🇷🇺',
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageCard(
                    context,
                    ref,
                    'Тоҷикӣ',
                    const Locale('tg'),
                    '🇹🇯',
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageCard(
                    context,
                    ref,
                    'English',
                    const Locale('en'),
                    '🇺🇸',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    WidgetRef ref,
    String label,
    Locale locale,
    String flag,
  ) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      fillOpacity: 0.6,
      borderOpacity: 0.2,
      borderColor: AppTheme.mondeluxPrimary,
      padding: EdgeInsets.zero, // Handle padding in InkWell
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(languageProvider.notifier).setLocale(locale);
            context.go('/tips');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Flag Container
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 16),
                // Language Name
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mondeluxPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
