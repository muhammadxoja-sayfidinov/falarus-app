import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'package:falarus/core/design/app_theme.dart';
import 'package:falarus/core/design/background_scaffold.dart';
import 'package:falarus/core/design/glass_container.dart';
import 'package:falarus/core/utils/toast_utils.dart';
import 'package:falarus/features/auth/presentation/auth_controller.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';

class SmsVerificationScreen extends ConsumerStatefulWidget {
  const SmsVerificationScreen({super.key});

  @override
  ConsumerState<SmsVerificationScreen> createState() =>
      _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends ConsumerState<SmsVerificationScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: GoogleFonts.outfit(
        fontSize: 22,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppTheme.mondeluxBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.mondeluxPrimary.withValues(alpha: 0.2),
        ),
      ),
    );

    // Listen for errors and show toast
    ref.listen(authProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ToastUtils.showError(context, next.error!);
      }
    });

    return BackgroundScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.mondeluxPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sms_outlined,
                size: 60,
                color: AppTheme.mondeluxPrimary,
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.verificationTitle,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(
                  context,
                )!.verificationSubtitle(authState.phoneNumber ?? ""),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              GlassContainer(
                color: AppTheme.mondeluxSurfaceSecond,
                child: Column(
                  children: [
                    Pinput(
                      length: 6,
                      controller: _codeController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: AppTheme.mondeluxPrimary),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: AppTheme.mondeluxPrimary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) {
                        // Optional: Auto-submit here
                      },
                    ),
                    const SizedBox(height: 32),
                    if (authState.error != null) const SizedBox.shrink(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.status == AuthStatus.loading
                            ? null
                            : () async {
                                final code = _codeController.text;
                                if (code.length == 6) {
                                  final success = await ref
                                      .read(authProvider.notifier)
                                      .verifyCode(code);

                                  if (success && context.mounted) {
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      final doc = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .get();

                                      final hasName =
                                          doc.exists &&
                                          doc.data()!.containsKey(
                                            'firstName',
                                          ) &&
                                          doc.data()!['firstName'] != null &&
                                          doc
                                              .data()!['firstName']
                                              .toString()
                                              .isNotEmpty;

                                      if (context.mounted) {
                                        if (hasName) {
                                          context.go('/loading');
                                        } else {
                                          context.go('/user-info');
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.mondeluxPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          splashFactory: NoSplash.splashFactory,
                          shadowColor: Colors.transparent,
                        ),
                        child: authState.status == AuthStatus.loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.verifyCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
