import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('fil'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LTO Exam Coach'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Philippines Driver\'s License Reviewer'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navMockTest.
  ///
  /// In en, this message translates to:
  /// **'Mock Exam'**
  String get navMockTest;

  /// No description provided for @navRoadSigns.
  ///
  /// In en, this message translates to:
  /// **'Road Signs'**
  String get navRoadSigns;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @greetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to practice?'**
  String get greetingTitle;

  /// No description provided for @preparingForPrefix.
  ///
  /// In en, this message translates to:
  /// **'Preparing for: '**
  String get preparingForPrefix;

  /// No description provided for @continuePractice.
  ///
  /// In en, this message translates to:
  /// **'Continue Practice'**
  String get continuePractice;

  /// No description provided for @questionsLeftToReview.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions Left to Review'**
  String questionsLeftToReview(int count);

  /// No description provided for @allQuestionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'All 150 Questions Completed!'**
  String get allQuestionsCompleted;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @dayUnit.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayUnit;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysUnit;

  /// No description provided for @studyModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Modes & Review'**
  String get studyModesTitle;

  /// No description provided for @modePracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Questions'**
  String get modePracticeTitle;

  /// No description provided for @modePracticeDesc.
  ///
  /// In en, this message translates to:
  /// **'Topic Practice'**
  String get modePracticeDesc;

  /// No description provided for @modeMockExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Mock Exam'**
  String get modeMockExamTitle;

  /// No description provided for @modeMockExamDesc.
  ///
  /// In en, this message translates to:
  /// **'Timed Simulation'**
  String get modeMockExamDesc;

  /// No description provided for @modeWrongAnswersTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answers'**
  String get modeWrongAnswersTitle;

  /// No description provided for @modeWrongAnswersDesc.
  ///
  /// In en, this message translates to:
  /// **'Mistake Bank'**
  String get modeWrongAnswersDesc;

  /// No description provided for @modeFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get modeFavoritesTitle;

  /// No description provided for @modeFavoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Saved Questions'**
  String get modeFavoritesDesc;

  /// No description provided for @modeDifficultTitle.
  ///
  /// In en, this message translates to:
  /// **'Difficult Questions'**
  String get modeDifficultTitle;

  /// No description provided for @modeDifficultDesc.
  ///
  /// In en, this message translates to:
  /// **'Flagged Questions'**
  String get modeDifficultDesc;

  /// No description provided for @modeRoadSignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Road Signs'**
  String get modeRoadSignsTitle;

  /// No description provided for @modeRoadSignsDesc.
  ///
  /// In en, this message translates to:
  /// **'45 Visual Signs'**
  String get modeRoadSignsDesc;

  /// No description provided for @modeProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress & Analytics'**
  String get modeProgressTitle;

  /// No description provided for @modeProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Streak'**
  String get modeProgressDesc;

  /// No description provided for @tipOfTheDayPrefix.
  ///
  /// In en, this message translates to:
  /// **'Tip of the Day: '**
  String get tipOfTheDayPrefix;

  /// No description provided for @legalDisclaimerCompact.
  ///
  /// In en, this message translates to:
  /// **'Independent study reviewer. Not affiliated with or endorsed by the Land Transportation Office (LTO).'**
  String get legalDisclaimerCompact;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get sectionGeneral;

  /// No description provided for @sectionStudy.
  ///
  /// In en, this message translates to:
  /// **'STUDY'**
  String get sectionStudy;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get sectionAbout;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFilipino.
  ///
  /// In en, this message translates to:
  /// **'Filipino'**
  String get languageFilipino;

  /// No description provided for @settingDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get settingDarkTheme;

  /// No description provided for @settingDarkThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle app dark mode appearance'**
  String get settingDarkThemeDesc;

  /// No description provided for @settingDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Study Reminder'**
  String get settingDailyReminder;

  /// No description provided for @settingDailyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified to practice every day'**
  String get settingDailyReminderDesc;

  /// No description provided for @settingVehicleCategory.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Category'**
  String get settingVehicleCategory;

  /// No description provided for @settingVehicleCategoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalize practice for your target license'**
  String get settingVehicleCategoryDesc;

  /// No description provided for @settingDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Practice Goal'**
  String get settingDailyGoal;

  /// No description provided for @settingDailyGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions per day'**
  String settingDailyGoalDesc(int count);

  /// No description provided for @settingAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingAppVersion;

  /// No description provided for @settingAboutLegal.
  ///
  /// In en, this message translates to:
  /// **'About & Legal Disclaimer'**
  String get settingAboutLegal;

  /// No description provided for @settingPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingPrivacyPolicy;

  /// No description provided for @settingPrivacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Information on offline data and privacy'**
  String get settingPrivacyPolicyDesc;

  /// No description provided for @settingAdPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Ad Privacy & Consent'**
  String get settingAdPrivacy;

  /// No description provided for @settingAdPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your advertising & consent preferences'**
  String get settingAdPrivacyDesc;

  /// No description provided for @settingResetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Practice Progress'**
  String get settingResetProgress;

  /// No description provided for @settingResetProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear practice statistics, category accuracy, and streak'**
  String get settingResetProgressDesc;

  /// No description provided for @practiceByTopic.
  ///
  /// In en, this message translates to:
  /// **'Practice by Topic'**
  String get practiceByTopic;

  /// No description provided for @allQuestions.
  ///
  /// In en, this message translates to:
  /// **'All Questions'**
  String get allQuestions;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionNumber(int current, int total);

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @finishPractice.
  ///
  /// In en, this message translates to:
  /// **'Finish Practice'**
  String get finishPractice;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice Complete!'**
  String get practiceComplete;

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get practiceAgain;

  /// No description provided for @backToTopics.
  ///
  /// In en, this message translates to:
  /// **'Back to Topics'**
  String get backToTopics;

  /// No description provided for @mockExam.
  ///
  /// In en, this message translates to:
  /// **'Mock Exam'**
  String get mockExam;

  /// No description provided for @practiceBenchmarkNotice.
  ///
  /// In en, this message translates to:
  /// **'80% Practice Benchmark'**
  String get practiceBenchmarkNotice;

  /// No description provided for @mockExamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Timed practice examination for driver\'s license preparation.'**
  String get mockExamSubtitle;

  /// No description provided for @startMockExam.
  ///
  /// In en, this message translates to:
  /// **'Start Mock Exam'**
  String get startMockExam;

  /// No description provided for @questionsCount20.
  ///
  /// In en, this message translates to:
  /// **'20 Questions'**
  String get questionsCount20;

  /// No description provided for @questionsCount30.
  ///
  /// In en, this message translates to:
  /// **'30 Questions'**
  String get questionsCount30;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @submitExam.
  ///
  /// In en, this message translates to:
  /// **'Submit Exam'**
  String get submitExam;

  /// No description provided for @practiceResult.
  ///
  /// In en, this message translates to:
  /// **'Practice Result'**
  String get practiceResult;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;
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
      <String>['en', 'fil'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
