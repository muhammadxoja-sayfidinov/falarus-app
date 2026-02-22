import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('tg'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FalaRus'**
  String get appTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare for your future.'**
  String get loginSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @startExam.
  ///
  /// In en, this message translates to:
  /// **'Start Exam'**
  String get startExam;

  /// No description provided for @selectCourse.
  ///
  /// In en, this message translates to:
  /// **'Select Course'**
  String get selectCourse;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get ticket;

  /// No description provided for @ticketComplete.
  ///
  /// In en, this message translates to:
  /// **'Ticket Complete'**
  String get ticketComplete;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @errorLoadingTicket.
  ///
  /// In en, this message translates to:
  /// **'Error loading ticket'**
  String get errorLoadingTicket;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @typeYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get typeYourAnswer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get subscription;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get free;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Full Access'**
  String get premium;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @youArePremium.
  ///
  /// In en, this message translates to:
  /// **'Full Access Active'**
  String get youArePremium;

  /// No description provided for @variant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get variant;

  /// No description provided for @audioQuestion.
  ///
  /// In en, this message translates to:
  /// **'Audio Question'**
  String get audioQuestion;

  /// No description provided for @questionsOf.
  ///
  /// In en, this message translates to:
  /// **'Question {n} of {m}'**
  String questionsOf(Object m, Object n);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading resources...'**
  String get loading;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer: {answer}'**
  String correctAnswer(Object answer);

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @mistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get mistakes;

  /// No description provided for @currentScore.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get currentScore;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @verificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {phone}'**
  String verificationSubtitle(Object phone);

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @variants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get variants;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'About You'**
  String get aboutYou;

  /// No description provided for @enterDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterDetailsSubtitle;

  /// No description provided for @firstNameInput.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameInput;

  /// No description provided for @lastNameInput.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameInput;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @settingUpExam.
  ///
  /// In en, this message translates to:
  /// **'Setting up your exam'**
  String get settingUpExam;

  /// No description provided for @downloadingResources.
  ///
  /// In en, this message translates to:
  /// **'We are downloading questions and images so your exam runs smoothly.'**
  String get downloadingResources;

  /// No description provided for @resolvingAssets.
  ///
  /// In en, this message translates to:
  /// **'Resolving assets...'**
  String get resolvingAssets;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @courseContentStats.
  ///
  /// In en, this message translates to:
  /// **'{variantCount} Variants | {questionCount} Questions'**
  String courseContentStats(Object questionCount, Object variantCount);

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'00 000 00 00'**
  String get phoneHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @tip1Title.
  ///
  /// In en, this message translates to:
  /// **'Learn Anywhere'**
  String get tip1Title;

  /// No description provided for @tip1Desc.
  ///
  /// In en, this message translates to:
  /// **'Access your courses and exams from anywhere, anytime.'**
  String get tip1Desc;

  /// No description provided for @tip2Title.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get tip2Title;

  /// No description provided for @tip2Desc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your results and see how you improve over time.'**
  String get tip2Desc;

  /// No description provided for @tip3Title.
  ///
  /// In en, this message translates to:
  /// **'Pass Exams'**
  String get tip3Title;

  /// No description provided for @tip3Desc.
  ///
  /// In en, this message translates to:
  /// **'Get ready for your exams with our comprehensive tests.'**
  String get tip3Desc;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @deleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.'**
  String get deleteAccountContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'tg', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tg':
      return AppLocalizationsTg();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
