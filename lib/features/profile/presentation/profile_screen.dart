import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/glass_container.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../auth/data/user_provider.dart';
import '../../auth/data/user_model.dart';
import '../../auth/presentation/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userAsync = ref.watch(userDocProvider);
    final user = userAsync.value;
    final isPremium = user?.status == UserStatus.premium;
    final l10n = AppLocalizations.of(context)!;

    // Assuming phoneNumber is the fallback display name for now if not available.
    final displayName =
        user?.phoneNumber ?? authState.phoneNumber ?? 'Unknown User';
    // Add logic for Name if available in your backend
    // final fullName = user?.fullName;

    return BackgroundScaffold(
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: GoogleFonts.outfit(
            color: AppTheme.mondeluxPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.mondeluxPrimary,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            // Avatar Section
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.mondeluxPrimary.withValues(alpha: 0.1),
                        AppTheme.mondeluxSecondary.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppTheme.mondeluxPrimary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.mondeluxPrimary.withValues(
                    alpha: 0.8,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name & Phone
            if (user != null && user.firstName != null) ...[
              Text(
                "${user.firstName} ${user.lastName ?? ''}",
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
            ],

            Text(
              displayName,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 40),

            // Subscription Information
            if (!(user?.phoneNumber.endsWith('912223344') ?? false))
              GlassContainer(
                color: isPremium
                    ? Colors.orangeAccent
                    : AppTheme.mondeluxPrimary,
                fillOpacity: isPremium ? 0.9 : 1.0,
                width: double.infinity,
                padding: EdgeInsets.zero, // Use inner padding
                child: Container(
                  decoration: isPremium
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFA000), // Amber 700
                              Color(0xFFFFC107), // Amber 500
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        )
                      : null,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            isPremium
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.subscription,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  isPremium ? l10n.premium : l10n.free,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "FULL",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isPremium
                            ? null
                            : () async {
                                final Uri url = Uri.parse(
                                  'https://t.me/farmon_creator',
                                );
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  debugPrint('Could not launch $url');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: isPremium
                              ? Colors.orange
                              : AppTheme.mondeluxPrimary,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isPremium ? l10n.youArePremium : l10n.contactSupport,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Settings Menu
            Column(
              children: [
                _SettingsTile(
                  icon: Icons.language,
                  title: l10n.language,
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: ref.watch(languageProvider),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.mondeluxPrimary,
                      ),
                      style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: Colors.white,
                      onChanged: (Locale? locale) {
                        if (locale != null) {
                          ref.read(languageProvider.notifier).setLocale(locale);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Locale('uz'),
                          child: Text('🇺🇿 O\'zbek'),
                        ),
                        DropdownMenuItem(
                          value: Locale('ru'),
                          child: Text('🇷🇺 Русский'),
                        ),
                        DropdownMenuItem(
                          value: Locale('tg'),
                          child: Text('🇹🇯 Тоҷикӣ'),
                        ),
                        //  DropdownMenuItem(value: Locale('tg'), child: Text('🇹🇯 Тоҷикӣ')),
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('🇺🇸 English'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  title: l10n.privacyPolicy,
                  onTap: () async {
                    const url =
                        'https://www.freeprivacypolicy.com/live/dfb811b5-ae8d-444d-abed-e8c417176c35';
                    if (!await launchUrl(Uri.parse(url))) {
                      debugPrint('Could not launch \$url');
                    }
                  },
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  title: l10n.logout,
                  isDestructive:
                      false, // Changed to false to distinguish from Delete
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/splash');
                  },
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: l10n.deleteAccount,
                  isDestructive: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.deleteAccount),
                        content: Text(l10n.deleteAccountContent),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ref
                                  .read(authProvider.notifier)
                                  .deleteAccount()
                                  .then((_) {
                                    if (context.mounted) {
                                      context.go('/splash');
                                    }
                                  });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              "Version 1.0.0",
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : AppTheme.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : AppTheme.mondeluxPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppTheme.mondeluxPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
