import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/app.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/home/home_screen.dart';
import 'package:lto_exam_coach/screens/onboarding/onboarding_screen.dart';
import 'package:lto_exam_coach/screens/onboarding/vehicle_selection_screen.dart';
import 'package:lto_exam_coach/services/storage_service.dart';

void main() {
  late StorageService storageService;
  late SettingsProvider settingsProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
    settingsProvider = SettingsProvider(storageService);
  });

  Widget createWidgetUnderTest({Widget? child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider,
        ),
      ],
      child: MaterialApp(
        home: child ?? const LtoExamCoachApp(),
      ),
    );
  }

  testWidgets('1. New user sees onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
          ),
        ],
        child: const LtoExamCoachApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prepare Smarter'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('2. Skip opens vehicle selection screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
          ),
        ],
        child: const LtoExamCoachApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('What are you preparing for?'), findsOneWidget);
  });

  testWidgets('3. Get Started completes onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
          ),
        ],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Next twice to get to page 3
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('What are you preparing for?'), findsOneWidget);
  });

  testWidgets('4. Vehicle selection is saved to provider and storage',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(child: const VehicleSelectionScreen()));
    await tester.pumpAndSettle();

    // Select Motorcycle
    await tester.tap(find.text('Motorcycle'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save & Continue'));
    await tester.pumpAndSettle();

    expect(settingsProvider.vehicleType, 'motorcycle');
    expect(settingsProvider.onboardingCompleted, true);
  });

  testWidgets('5. Returning user skips onboarding', (WidgetTester tester) async {
    await settingsProvider.completeOnboarding();
    await settingsProvider.setVehicleType('car');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
          ),
        ],
        child: const LtoExamCoachApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('LTO Exam Coach'), findsOneWidget);
    expect(find.text('Prepare Smarter'), findsNothing);
  });

  testWidgets('6. Home screen renders correctly with vehicle settings',
      (WidgetTester tester) async {
    await settingsProvider.setVehicleType('car');

    await tester.pumpWidget(createWidgetUnderTest(child: const HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Ready to practice?'), findsOneWidget);
    expect(find.text('Preparing for: Car'), findsOneWidget);
    expect(find.text('Continue Practice'), findsOneWidget);
    expect(find.textContaining('Tip of the Day:'), findsOneWidget);
  });

  testWidgets('7. Quick action navigation callback triggers correctly',
      (WidgetTester tester) async {
    int navigatedTabIndex = -1;

    await tester.pumpWidget(
      createWidgetUnderTest(
        child: HomeScreen(
          onNavigateTab: (index) {
            navigatedTabIndex = index;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Continue Practice button
    await tester.tap(find.text('Start Practice'));
    await tester.pumpAndSettle();

    expect(navigatedTabIndex, 1);
  });

  testWidgets('8. Dark theme toggle updates theme mode', (WidgetTester tester) async {
    expect(settingsProvider.themeMode, ThemeMode.light);

    await settingsProvider.setThemeMode(ThemeMode.dark);
    expect(settingsProvider.themeMode, ThemeMode.dark);

    await settingsProvider.setThemeMode(ThemeMode.light);
    expect(settingsProvider.themeMode, ThemeMode.light);
  });
}
