// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appTitle => 'FalaRus';

  @override
  String get loginSubtitle => 'Ба ояндаи худ омода шавед.';

  @override
  String get welcomeBack => 'Хуш омадед';

  @override
  String get phoneNumber => 'Рақами телефон';

  @override
  String get getStarted => 'Оғоз кардан';

  @override
  String get courses => 'Курсҳо';

  @override
  String get profile => 'Профил';

  @override
  String get startExam => 'Оғози Имтиҳон';

  @override
  String get selectCourse => 'Курсро интихоб кунед';

  @override
  String get tickets => 'Билетҳо';

  @override
  String get ticket => 'Вариант';

  @override
  String get ticketComplete => 'Билет ба охир расид';

  @override
  String get correctAnswers => 'Ҷавобҳои дуруст';

  @override
  String get finish => 'Тамом кардан';

  @override
  String get errorLoadingTicket => 'Хатогӣ дар боргирии билет';

  @override
  String get previous => 'Қаблӣ';

  @override
  String get next => 'Баъдӣ';

  @override
  String get submit => 'Супоридан';

  @override
  String get typeYourAnswer => 'Ҷавоби худро дар ин ҷо нависед...';

  @override
  String get settings => 'Танзимот';

  @override
  String get language => 'Забон';

  @override
  String get logout => 'Баромадан';

  @override
  String get subscription => 'Обуна';

  @override
  String get free => 'Ройгон';

  @override
  String get premium => 'Премиум';

  @override
  String get upgradeToPremium => 'Гузариш ба Премиум';

  @override
  String get youArePremium => 'Шумо Премиум доред';

  @override
  String get variant => 'Вариант';

  @override
  String get audioQuestion => 'Саволи Аудиоӣ';

  @override
  String questionsOf(Object m, Object n) {
    return 'Саволи $n аз $m';
  }

  @override
  String get loading => 'Боргирии захираҳо...';

  @override
  String get passed => 'Гузашт';

  @override
  String get failed => 'Нагузашт';

  @override
  String get locked => 'Масдуд';

  @override
  String get open => 'Кушода';

  @override
  String get inProgress => 'Дар раванд';

  @override
  String correctAnswer(Object answer) {
    return 'Ҷавоби дуруст: $answer';
  }

  @override
  String get correct => 'Дуруст!';

  @override
  String get mistakes => 'Хато';

  @override
  String get currentScore => 'Дуруст';

  @override
  String get verificationTitle => 'Тасдиқ';

  @override
  String verificationSubtitle(Object phone) {
    return 'Мо ба рақами $phone рамз фиристодем';
  }

  @override
  String get verifyCode => 'Тасдиқи рамз';

  @override
  String get variants => 'Вариантҳо';

  @override
  String get questions => 'Саволҳо';

  @override
  String get comingSoon => 'Ба зудӣ';

  @override
  String get aboutYou => 'Дар бораи шумо';

  @override
  String get enterDetailsSubtitle => 'Лутфан номи худро ворид кунед';

  @override
  String get firstNameInput => 'Ном';

  @override
  String get lastNameInput => 'Насаб';

  @override
  String get continueButton => 'Идома додан';

  @override
  String get settingUpExam => 'Танзими имтиҳон';

  @override
  String get downloadingResources =>
      'Мо саволҳо ва тасвирҳоро боргирӣ карда истодаем, то имтиҳон бе мушкилӣ гузарад.';

  @override
  String get resolvingAssets => 'Коркарди захираҳо...';

  @override
  String get initializing => 'Омодасозӣ...';

  @override
  String courseContentStats(Object questionCount, Object variantCount) {
    return '$variantCount Вариант | $questionCount Савол';
  }

  @override
  String get phoneHint => '00 000 00 00';

  @override
  String get requiredField => 'Ҳатмӣ';

  @override
  String get tip1Title => 'Дар ҳама ҷо омӯзед';

  @override
  String get tip1Desc =>
      'Дастрасӣ ба курсҳо ва имтиҳонҳо дар ҳама вақт ва ҳама ҷо.';

  @override
  String get tip2Title => 'Натиҷаҳоро пайгирӣ кунед';

  @override
  String get tip2Desc =>
      'Натиҷаҳои худро назорат кунед ва пешрафти худро бубинед.';

  @override
  String get tip3Title => 'Имтиҳонҳоро супоред';

  @override
  String get tip3Desc => 'Бо тестҳои ҳамаҷонибаи мо ба имтиҳонҳо омода шавед.';
}
