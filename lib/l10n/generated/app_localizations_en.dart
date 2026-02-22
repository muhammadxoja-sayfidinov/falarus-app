// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FalaRus';

  @override
  String get loginSubtitle => 'Prepare for your future.';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get getStarted => 'Get Started';

  @override
  String get courses => 'Courses';

  @override
  String get profile => 'Profile';

  @override
  String get startExam => 'Start Exam';

  @override
  String get selectCourse => 'Select Course';

  @override
  String get tickets => 'Tickets';

  @override
  String get ticket => 'Variant';

  @override
  String get ticketComplete => 'Ticket Complete';

  @override
  String get correctAnswers => 'Correct Answers';

  @override
  String get finish => 'Finish';

  @override
  String get errorLoadingTicket => 'Error loading ticket';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get typeYourAnswer => 'Type your answer here...';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get subscription => 'Status';

  @override
  String get free => 'Standard';

  @override
  String get premium => 'Full Access';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get youArePremium => 'Full Access Active';

  @override
  String get variant => 'Variant';

  @override
  String get audioQuestion => 'Audio Question';

  @override
  String questionsOf(Object m, Object n) {
    return 'Question $n of $m';
  }

  @override
  String get loading => 'Loading resources...';

  @override
  String get passed => 'Passed';

  @override
  String get failed => 'Failed';

  @override
  String get locked => 'Locked';

  @override
  String get open => 'Open';

  @override
  String get inProgress => 'In Progress';

  @override
  String correctAnswer(Object answer) {
    return 'Correct Answer: $answer';
  }

  @override
  String get correct => 'Correct!';

  @override
  String get mistakes => 'Mistakes';

  @override
  String get currentScore => 'Correct';

  @override
  String get verificationTitle => 'Verification';

  @override
  String verificationSubtitle(Object phone) {
    return 'We sent a code to $phone';
  }

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get variants => 'Variants';

  @override
  String get questions => 'Questions';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get aboutYou => 'About You';

  @override
  String get enterDetailsSubtitle => 'Please enter your name';

  @override
  String get firstNameInput => 'First Name';

  @override
  String get lastNameInput => 'Last Name';

  @override
  String get continueButton => 'Continue';

  @override
  String get settingUpExam => 'Setting up your exam';

  @override
  String get downloadingResources =>
      'We are downloading questions and images so your exam runs smoothly.';

  @override
  String get resolvingAssets => 'Resolving assets...';

  @override
  String get initializing => 'Initializing...';

  @override
  String courseContentStats(Object questionCount, Object variantCount) {
    return '$variantCount Variants | $questionCount Questions';
  }

  @override
  String get phoneHint => '00 000 00 00';

  @override
  String get requiredField => 'Required';

  @override
  String get tip1Title => 'Learn Anywhere';

  @override
  String get tip1Desc =>
      'Access your courses and exams from anywhere, anytime.';

  @override
  String get tip2Title => 'Track Progress';

  @override
  String get tip2Desc =>
      'Monitor your results and see how you improve over time.';

  @override
  String get tip3Title => 'Pass Exams';

  @override
  String get tip3Desc =>
      'Get ready for your exams with our comprehensive tests.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get deleteAccountContent =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';
}
