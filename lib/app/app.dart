import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

import '../services/ad_service.dart';

class LtoExamCoachApp extends StatefulWidget {
  const LtoExamCoachApp({super.key});

  @override
  State<LtoExamCoachApp> createState() => _LtoExamCoachAppState();
}

class _LtoExamCoachAppState extends State<LtoExamCoachApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdService.instance.showColdStartAppOpenAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.themeMode,
      locale: settingsProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: settingsProvider.onboardingCompleted
          ? AppRoutes.main
          : AppRoutes.onboarding,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
