import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/app.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/services/storage_service.dart';

void main() {
  testWidgets('MainNavigationScreen launches with bottom navigation bar',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    await storageService.setOnboardingCompleted(true);

    final settingsProvider = SettingsProvider(storageService);

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

    // Verify main app title and bottom navigation labels
    expect(find.text('LTO Exam Coach'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Mock Test'), findsWidgets);
    expect(find.text('Progress'), findsOneWidget);
  });
}
