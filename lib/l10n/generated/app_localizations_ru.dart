// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'FalaRus';

  @override
  String get loginSubtitle => 'Готовьтесь к своему будущему.';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get getStarted => 'Начать';

  @override
  String get courses => 'Курсы';

  @override
  String get profile => 'Профиль';

  @override
  String get startExam => 'Начать Экзамен';

  @override
  String get selectCourse => 'Выберите Курс';

  @override
  String get tickets => 'Билеты';

  @override
  String get ticket => 'Вариант';

  @override
  String get ticketComplete => 'Билет Завершен';

  @override
  String get correctAnswers => 'Правильные Ответы';

  @override
  String get finish => 'Завершить';

  @override
  String get errorLoadingTicket => 'Ошибка загрузки билета';

  @override
  String get previous => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get submit => 'Отправить';

  @override
  String get typeYourAnswer => 'Введите ваш ответ здесь...';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get logout => 'Выйти';

  @override
  String get subscription => 'Подписка';

  @override
  String get free => 'Бесплатно';

  @override
  String get premium => 'Премиум';

  @override
  String get upgradeToPremium => 'Перейти на Премиум';

  @override
  String get youArePremium => 'У вас Премиум';

  @override
  String get variant => 'Вариант';

  @override
  String get audioQuestion => 'Аудио вопрос';

  @override
  String questionsOf(Object m, Object n) {
    return 'Вопрос $n из $m';
  }

  @override
  String get loading => 'Загрузка ресурсов...';

  @override
  String get passed => 'Сдал';

  @override
  String get failed => 'Не сдал';

  @override
  String get locked => 'Закрыто';

  @override
  String get open => 'Открыто';

  @override
  String get inProgress => 'В процессе';

  @override
  String correctAnswer(Object answer) {
    return 'Правильный ответ: $answer';
  }

  @override
  String get correct => 'Верно!';

  @override
  String get mistakes => 'Ошибок';

  @override
  String get currentScore => 'Верно';

  @override
  String get verificationTitle => 'Подтверждение';

  @override
  String verificationSubtitle(Object phone) {
    return 'Мы отправили код на $phone';
  }

  @override
  String get verifyCode => 'Подтвердить код';

  @override
  String get variants => 'Вариантов';

  @override
  String get questions => 'Вопросов';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get aboutYou => 'О вас';

  @override
  String get enterDetailsSubtitle => 'Пожалуйста, введите ваше имя';

  @override
  String get firstNameInput => 'Имя';

  @override
  String get lastNameInput => 'Фамилия';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get settingUpExam => 'Подготовка экзамена';

  @override
  String get downloadingResources =>
      'Мы загружаем вопросы и изображения для корректной работы экзамена.';

  @override
  String get resolvingAssets => 'Обработка ресурсов...';

  @override
  String get initializing => 'Инициализация...';

  @override
  String courseContentStats(Object questionCount, Object variantCount) {
    return '$variantCount Вариантов | $questionCount Вопросов';
  }

  @override
  String get phoneHint => '00 000 00 00';

  @override
  String get requiredField => 'Обязательно';

  @override
  String get tip1Title => 'Учитесь везде';

  @override
  String get tip1Desc =>
      'Доступ к курсам и экзаменам в любое время и в любом месте.';

  @override
  String get tip2Title => 'Следите за прогрессом';

  @override
  String get tip2Desc =>
      'Контролируйте свои результаты и наблюдайте за улучшениями.';

  @override
  String get tip3Title => 'Сдавайте экзамены';

  @override
  String get tip3Desc =>
      'Подготовьтесь к экзаменам с помощью наших комплексных тестов.';
}
