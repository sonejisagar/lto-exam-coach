// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appName => 'LTO Exam Coach';

  @override
  String get appTagline => 'Tagapagsanay sa Lisensya sa Pagmamaneho';

  @override
  String get navHome => 'Tahanan';

  @override
  String get navPractice => 'Pagsasanay';

  @override
  String get navMockTest => 'Mock Exam';

  @override
  String get navRoadSigns => 'Mga Senyas';

  @override
  String get navProgress => 'Progreso';

  @override
  String get greetingTitle => 'Handa ka na bang magsanay?';

  @override
  String get preparingForPrefix => 'Paghahanda para sa: ';

  @override
  String get continuePractice => 'Ipagpatuloy ang Pagsasanay';

  @override
  String questionsLeftToReview(int count) {
    return '$count mga tanong na natitira';
  }

  @override
  String get allQuestionsCompleted => 'Lahat ng 150 tanong ay natapos na!';

  @override
  String get startPractice => 'Simulan ang Pagsasanay';

  @override
  String get todaysSummary => 'Buod Ngayong Araw';

  @override
  String get today => 'Ngayong Araw';

  @override
  String get accuracy => 'Katumpakan';

  @override
  String get streak => 'Streak';

  @override
  String get dayUnit => 'Araw';

  @override
  String get daysUnit => 'mga Araw';

  @override
  String get studyModesTitle => 'Mga Paraan ng Pag-aaral';

  @override
  String get modePracticeTitle => 'Pagsasanay sa mga Tanong';

  @override
  String get modePracticeDesc => 'Pagsasanay bawat Paksa';

  @override
  String get modeMockExamTitle => 'Mock Exam';

  @override
  String get modeMockExamDesc => 'Orasang Pagsusulit';

  @override
  String get modeWrongAnswersTitle => 'Maling mga Sagot';

  @override
  String get modeWrongAnswersDesc => 'Bangko ng Pagkakamali';

  @override
  String get modeFavoritesTitle => 'Mga Paborito';

  @override
  String get modeFavoritesDesc => 'Nai-save na mga Tanong';

  @override
  String get modeDifficultTitle => 'Mahihirap na Tanong';

  @override
  String get modeDifficultDesc => 'May Markang mga Tanong';

  @override
  String get modeRoadSignsTitle => 'Mga Senyas sa Daan';

  @override
  String get modeRoadSignsDesc => '45 Nakalarawang Senyas';

  @override
  String get modeProgressTitle => 'Progreso at Analytics';

  @override
  String get modeProgressDesc => 'Estadistika at Streak';

  @override
  String get tipOfTheDayPrefix => 'Tip para sa Araw na Ito: ';

  @override
  String get legalDisclaimerCompact =>
      'Independyenteng reviewer sa pag-aaral. Hindi kaakibat o opisyal na itinataguyod ng LTO.';

  @override
  String get settingsTitle => 'Mga Setting';

  @override
  String get sectionGeneral => 'PANGKALAHATAN';

  @override
  String get sectionStudy => 'PAG-AARAL';

  @override
  String get sectionAbout => 'TUNGKOL SA APP';

  @override
  String get settingLanguage => 'Wika';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFilipino => 'Filipino';

  @override
  String get settingDarkTheme => 'Dark Theme';

  @override
  String get settingDarkThemeDesc => 'I-toggle ang hitsura ng madilim na mode';

  @override
  String get settingDailyReminder => 'Pang-araw-araw na Paalala';

  @override
  String get settingDailyReminderDesc =>
      'Makatanggap ng abiso upang magsanay araw-araw';

  @override
  String get settingVehicleCategory => 'Kategorya ng Sasakyan';

  @override
  String get settingVehicleCategoryDesc =>
      'I-personalize ang pagsasanay para sa iyong target na lisensya';

  @override
  String get settingDailyGoal => 'Target na mga Tanong Bawat Araw';

  @override
  String settingDailyGoalDesc(int count) {
    return '$count Tanong bawat araw';
  }

  @override
  String get settingAppVersion => 'Bersyon ng App';

  @override
  String get settingAboutLegal => 'Tungkol at Legal na Disclaimer';

  @override
  String get settingPrivacyPolicy => 'Patakaran sa Pagkapribado';

  @override
  String get settingPrivacyPolicyDesc =>
      'Impormasyon sa offline na data at privacy';

  @override
  String get settingAdPrivacy => 'Privacy at Pahintulot sa Patalastas';

  @override
  String get settingAdPrivacyDesc =>
      'Pamahalaan ang iyong mga kagustuhan sa patalastas';

  @override
  String get settingResetProgress => 'I-reset ang Progreso ng Pagsasanay';

  @override
  String get settingResetProgressDesc =>
      'Burahin ang estadistika ng pagsasanay, katumpakan, at streak';

  @override
  String get practiceByTopic => 'Pagsasanay bawat Paksa';

  @override
  String get allQuestions => 'Lahat ng Tanong';

  @override
  String questionNumber(int current, int total) {
    return 'Tanong $current ng $total';
  }

  @override
  String get correct => 'Tama!';

  @override
  String get incorrect => 'Mali';

  @override
  String get explanation => 'Paliwanag';

  @override
  String get nextQuestion => 'Susunod na Tanong';

  @override
  String get finishPractice => 'Tapusin ang Pagsasanay';

  @override
  String get practiceComplete => 'Kumpleto na ang Pagsasanay!';

  @override
  String get practiceAgain => 'Magsanay Muli';

  @override
  String get backToTopics => 'Bumalik sa mga Paksa';

  @override
  String get mockExam => 'Mock Exam';

  @override
  String get practiceBenchmarkNotice => '80% Pamantayan sa Pagsasanay';

  @override
  String get mockExamSubtitle =>
      'Orasang pagsasanay na pagsusulit para sa paghahanda sa lisensya.';

  @override
  String get startMockExam => 'Simulan ang Mock Exam';

  @override
  String get questionsCount20 => '20 Tanong';

  @override
  String get questionsCount30 => '30 Tanong';

  @override
  String get timeRemaining => 'Natitirang Oras';

  @override
  String get submitExam => 'Isumite ang Pagsusulit';

  @override
  String get practiceResult => 'Resulta ng Pagsasanay';

  @override
  String get reviewAnswers => 'Suriin ang mga Sagot';

  @override
  String get tryAgain => 'Subukan Muli';

  @override
  String get backToHome => 'Bumalik sa Tahanan';
}
