import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/design/app_theme.dart';

import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/glass_container.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';

import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class Country {
  final String code;
  final String name;
  final String dialCode;
  final String flag;

  const Country({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
  });
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  final List<Country> _countries = const [
    Country(code: 'UZ', name: 'Uzbekistan', dialCode: '+998', flag: '🇺🇿'),
    Country(code: 'RU', name: 'Russia', dialCode: '+7', flag: '🇷🇺'),
    Country(code: 'KG', name: 'Kyrgyzstan', dialCode: '+996', flag: '🇰🇬'),
    Country(code: 'TJ', name: 'Tajikistan', dialCode: '+992', flag: '🇹🇯'),
  ];

  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.codeSent) {
        context.push('/verify');
      } else if (next.status == AuthStatus.authenticated &&
          next.autoCredential != null) {
        // Auto-resolution happened on login screen
        context.go('/loading');
      } else if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return BackgroundScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/logo.png', width: 80, height: 80),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.loginSubtitle,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 48),

              // Login Form
              GlassContainer(
                color: AppTheme.mondeluxSurfaceSecond,
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeBack,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Phone Input
                    Row(
                      children: [
                        // Country Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.mondeluxSurfaceSecond,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.textDisabled),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Country>(
                              value: _selectedCountry,
                              dropdownColor: AppTheme.mondeluxBackground,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.textPrimary,
                              ),
                              items: _countries.map((Country country) {
                                return DropdownMenuItem<Country>(
                                  value: country,
                                  child: Row(
                                    children: [
                                      Text(
                                        country.flag,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        country.dialCode,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (Country? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedCountry = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Phone Number TextField
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.phoneHint,
                              hintStyle: const TextStyle(
                                color: AppTheme.textDisabled,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.status == AuthStatus.loading
                            ? null
                            : () {
                                final phoneInput = _phoneController.text.trim();
                                if (phoneInput.isNotEmpty) {
                                  final fullPhone =
                                      '${_selectedCountry.dialCode}$phoneInput';
                                  ref
                                      .read(authProvider.notifier)
                                      .sendSms(fullPhone);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.mondeluxPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16, // Reduced from 24
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
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.getStarted,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
