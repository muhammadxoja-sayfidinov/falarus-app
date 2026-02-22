// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'FalaRus';

  @override
  String get loginSubtitle => 'Kelajagingizga tayyorlaning.';

  @override
  String get welcomeBack => 'Xush kelibsiz';

  @override
  String get phoneNumber => 'Telefon raqam';

  @override
  String get getStarted => 'Boshlash';

  @override
  String get courses => 'Kurslar';

  @override
  String get profile => 'Profil';

  @override
  String get startExam => 'Imtihonni Boshlash';

  @override
  String get selectCourse => 'Kursni Tanlang';

  @override
  String get tickets => 'Biletlar';

  @override
  String get ticket => 'Variant';

  @override
  String get ticketComplete => 'Chipta Tugatildi';

  @override
  String get correctAnswers => 'To\'g\'ri Javoblar';

  @override
  String get finish => 'Tugatish';

  @override
  String get errorLoadingTicket => 'Chiptani yuklashda xatolik';

  @override
  String get previous => 'Oldingi';

  @override
  String get next => 'Keyingi';

  @override
  String get submit => 'Topshirish';

  @override
  String get typeYourAnswer => 'Javobingizni shu yerga yozing...';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get language => 'Til';

  @override
  String get logout => 'Chiqish';

  @override
  String get subscription => 'Holat';

  @override
  String get free => 'Standart';

  @override
  String get premium => 'To\'liq kirish';

  @override
  String get upgradeToPremium => 'Premiumga o\'tish';

  @override
  String get youArePremium => 'To\'liq kirish faol';

  @override
  String get variant => 'Variant';

  @override
  String get audioQuestion => 'Audio Savol';

  @override
  String questionsOf(Object m, Object n) {
    return '$n-savol, jami $m ta';
  }

  @override
  String get loading => 'Resurslar yuklanmoqda...';

  @override
  String get passed => 'O\'tdi';

  @override
  String get failed => 'O\'tmadi';

  @override
  String get locked => 'Yopiq';

  @override
  String get open => 'Ochiq';

  @override
  String get inProgress => 'Jarayonda';

  @override
  String correctAnswer(Object answer) {
    return 'To\'g\'ri javob: $answer';
  }

  @override
  String get correct => 'To\'g\'ri!';

  @override
  String get mistakes => 'Xato';

  @override
  String get currentScore => 'To\'g\'ri';

  @override
  String get verificationTitle => 'Tasdiqlash';

  @override
  String verificationSubtitle(Object phone) {
    return 'Biz $phone raqamiga kod yubordik';
  }

  @override
  String get verifyCode => 'Kodni tasdiqlash';

  @override
  String get variants => 'Variantlar';

  @override
  String get questions => 'Savollar';

  @override
  String get comingSoon => 'Tez orada';

  @override
  String get aboutYou => 'Siz haqingizda';

  @override
  String get enterDetailsSubtitle => 'Iltimos, ismingizni kiriting';

  @override
  String get firstNameInput => 'Ism';

  @override
  String get lastNameInput => 'Familiya';

  @override
  String get continueButton => 'Davom etish';

  @override
  String get settingUpExam => 'Imtihonni sozlash';

  @override
  String get downloadingResources =>
      'Imtihon muammosiz ishlashi uchun savollar va rasmlarni yuklab olyapmiz.';

  @override
  String get resolvingAssets => 'Resurslar aniqlanmoqda...';

  @override
  String get initializing => 'Yuklanmoqda...';

  @override
  String courseContentStats(Object questionCount, Object variantCount) {
    return '$variantCount Variant | $questionCount Savol';
  }

  @override
  String get phoneHint => '00 000 00 00';

  @override
  String get requiredField => 'Majburiy';

  @override
  String get tip1Title => 'Istalgan joyda o\'rganing';

  @override
  String get tip1Desc =>
      'Kurslar va imtihonlarga istalgan vaqtda va istalgan joydan kiring.';

  @override
  String get tip2Title => 'Natijalarni kuzating';

  @override
  String get tip2Desc =>
      'Natijalaringizni tahlil qiling va o\'sish ko\'rsatkichlarini ko\'ring.';

  @override
  String get tip3Title => 'Imtihonlardan o\'ting';

  @override
  String get tip3Desc =>
      'Bizning keng qamrovli testlarimiz bilan imtihonlarga tayyorlaning.';

  @override
  String get deleteAccount => 'Hisobni o\'chirish';

  @override
  String get privacyPolicy => 'Maxfiylik siyosati';

  @override
  String get contactSupport => 'Qo\'llab-quvvatlash';

  @override
  String get deleteAccountContent =>
      'Hisobingizni o\'chirmoqchimisiz? Bu amalni ortga qaytarib bo\'lmaydi va barcha ma\'lumotlaringiz o\'chib ketadi.';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get delete => 'O\'chirish';
}
