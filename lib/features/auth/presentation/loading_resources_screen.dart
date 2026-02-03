import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';
import '../../../../core/utils/media_preloader.dart';
import '../../../l10n/generated/app_localizations.dart';

class LoadingResourcesScreen extends StatefulWidget {
  const LoadingResourcesScreen({super.key});

  @override
  State<LoadingResourcesScreen> createState() => _LoadingResourcesScreenState();
}

class _LoadingResourcesScreenState extends State<LoadingResourcesScreen> {
  double _progress = 0.0;
  String? _status;
  bool _isLoadingStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoadingStarted) {
      _isLoadingStarted = true;
      _status = AppLocalizations.of(context)?.initializing ?? "Initializing...";
      _startPreloading();
    }
  }

  Future<void> _startPreloading() async {
    final preloader = MediaPreloader();

    // Small delay to ensure UI renders first frame with "Initializing"
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      setState(() {
        _status =
            AppLocalizations.of(context)?.resolvingAssets ??
            "Resolving assets...";
      });
    }

    preloader.preloadAll().listen(
      (progress) {
        if (mounted) {
          setState(() {
            _progress = progress;
            final loadingText =
                AppLocalizations.of(context)?.loading ?? "Loading...";
            if (progress < 0.2) {
              _status = loadingText;
            } else {
              _status = "$loadingText (${(progress * 100).toInt()}%)";
            }
          });
        }
      },
      onDone: () {
        if (mounted) {
          context.go('/home'); // Or whatever the next route is
        }
      },
      onError: (e) {
        debugPrint("Preloading error: $e");
        if (mounted) {
          context.go('/home'); // Proceed anyway
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.mondeluxSecondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  AppLocalizations.of(context)!.settingUpExam,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  AppLocalizations.of(context)!.downloadingResources,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Progress Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: AppTheme.mondeluxPrimary.withValues(
                            alpha: 0.1,
                          ),
                          color: AppTheme.mondeluxPrimary,
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _status ??
                            AppLocalizations.of(context)?.initializing ??
                            "",
                        style: GoogleFonts.outfit(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
