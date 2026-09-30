// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LTO Exam Coach';

  @override
  String get appTagline => 'Philippines Driver\'s License Reviewer';

  @override
  String get navHome => 'Home';

  @override
  String get navPractice => 'Practice';

  @override
  String get navMockTest => 'Mock Exam';

  @override
  String get navRoadSigns => 'Road Signs';

  @override
  String get navProgress => 'Progress';

  @override
  String get greetingTitle => 'Ready to practice?';

  @override
  String get preparingForPrefix => 'Preparing for: ';

  @override
  String get continuePractice => 'Continue Practice';

  @override
  String questionsLeftToReview(int count) {
    return '$count Questions Left to Review';
  }

  @override
  String get allQuestionsCompleted => 'All 150 Questions Completed!';

  @override
  String get startPractice => 'Start Practice';

  @override
  String get todaysSummary => 'Today\'s Summary';

  @override
  String get today => 'Today';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get streak => 'Streak';

  @override
  String get dayUnit => 'Day';

  @override
  String get daysUnit => 'Days';

  @override
  String get studyModesTitle => 'Study Modes & Review';

  @override
  String get modePracticeTitle => 'Practice Questions';

  @override
  String get modePracticeDesc => 'Topic Practice';

  @override
  String get modeMockExamTitle => 'Mock Exam';

  @override
  String get modeMockExamDesc => 'Timed Simulation';

  @override
  String get modeWrongAnswersTitle => 'Wrong Answers';

  @override
  String get modeWrongAnswersDesc => 'Mistake Bank';

  @override
  String get modeFavoritesTitle => 'Favorites';

  @override
  String get modeFavoritesDesc => 'Saved Questions';

  @override
  String get modeDifficultTitle => 'Difficult Questions';

  @override
  String get modeDifficultDesc => 'Flagged Questions';

  @override
  String get modeRoadSignsTitle => 'Road Signs';

  @override
  String get modeRoadSignsDesc => '45 Visual Signs';

  @override
  String get modeProgressTitle => 'Progress & Analytics';

  @override
  String get modeProgressDesc => 'Analytics & Streak';

  @override
  String get tipOfTheDayPrefix => 'Tip of the Day: ';

  @override
  String get legalDisclaimerCompact =>
      'Independent study reviewer. Not affiliated with or endorsed by the Land Transportation Office (LTO).';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionGeneral => 'GENERAL';

  @override
  String get sectionStudy => 'STUDY';

  @override
  String get sectionAbout => 'ABOUT';

  @override
  String get settingLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFilipino => 'Filipino';

  @override
  String get settingDarkTheme => 'Dark Theme';

  @override
  String get settingDarkThemeDesc => 'Toggle app dark mode appearance';

  @override
  String get settingDailyReminder => 'Daily Study Reminder';

  @override
  String get settingDailyReminderDesc => 'Get notified to practice every day';

  @override
  String get settingVehicleCategory => 'Vehicle Category';

  @override
  String get settingVehicleCategoryDesc =>
      'Personalize practice for your target license';

  @override
  String get settingDailyGoal => 'Daily Practice Goal';

  @override
  String settingDailyGoalDesc(int count) {
    return '$count Questions per day';
  }

  @override
  String get settingAppVersion => 'App Version';

  @override
  String get settingAboutLegal => 'About & Legal Disclaimer';

  @override
  String get settingPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingPrivacyPolicyDesc =>
      'Information on offline data and privacy';

  @override
  String get settingAdPrivacy => 'Ad Privacy & Consent';

  @override
  String get settingAdPrivacyDesc =>
      'Manage your advertising & consent preferences';

  @override
  String get settingResetProgress => 'Reset Practice Progress';

  @override
  String get settingResetProgressDesc =>
      'Clear practice statistics, category accuracy, and streak';

  @override
  String get practiceByTopic => 'Practice by Topic';

  @override
  String get allQuestions => 'All Questions';

  @override
  String questionNumber(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get explanation => 'Explanation';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get finishPractice => 'Finish Practice';

  @override
  String get practiceComplete => 'Practice Complete!';

  @override
  String get practiceAgain => 'Practice Again';

  @override
  String get backToTopics => 'Back to Topics';

  @override
  String get mockExam => 'Mock Exam';

  @override
  String get practiceBenchmarkNotice => '80% Practice Benchmark';

  @override
  String get mockExamSubtitle =>
      'Timed practice examination for driver\'s license preparation.';

  @override
  String get startMockExam => 'Start Mock Exam';

  @override
  String get questionsCount20 => '20 Questions';

  @override
  String get questionsCount30 => '30 Questions';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get submitExam => 'Submit Exam';

  @override
  String get practiceResult => 'Practice Result';

  @override
  String get reviewAnswers => 'Review Answers';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get backToHome => 'Back to Home';
}
