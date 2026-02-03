import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/design/app_theme.dart';
import 'core/providers/language_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/sms_verification_screen.dart';
import 'features/auth/presentation/user_info_screen.dart';
import 'features/auth/presentation/loading_resources_screen.dart';
import 'features/courses/presentation/courses_list_screen.dart';
import 'features/courses/presentation/course_detail_screen.dart';
import 'features/exam/presentation/exam_runner_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/auth/presentation/language_selection_screen.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/onboarding/presentation/tips_screen.dart';
import 'core/localization/tg_localization_delegates.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint(
      "Firebase initialization failed (Config files likely missing): $e",
    );
    // Consider handling this better, maybe a dummy mode or error screen
  }
  runApp(const ProviderScope(child: LiquidExamApp()));
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/tips', builder: (context, state) => const TipsScreen()),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/user-info',
      builder: (context, state) => const UserInfoScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) => SmsVerificationScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingResourcesScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const CoursesListScreen(),
    ),
    GoRoute(
      path: '/course/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CourseDetailScreen(courseId: id);
      },
    ),
    GoRoute(
      path: '/exam/:ticketId',
      builder: (context, state) {
        final ticketId = state.pathParameters['ticketId']!;
        return ExamRunnerScreen(ticketId: ticketId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
  ],
);

class LiquidExamApp extends ConsumerWidget {
  const LiquidExamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Liquid Exam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mondeluxTheme,
      routerConfig: _router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        TgMaterialLocalizationsDelegate(),
        TgCupertinoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('uz'),
        Locale('ru'),
        Locale('tg'),
      ],
    );
  }
}
