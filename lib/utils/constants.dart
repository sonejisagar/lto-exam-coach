import 'package:flutter/material.dart';

class AppColors {
  // Phase 11 Dark Study Theme Palette
  static const Color darkBackground = Color(0xFF0B1115);
  static const Color darkSurface = Color(0xFF151D22);
  static const Color darkElevatedSurface = Color(0xFF1B252B);
  static const Color darkBorder = Color(0xFF26333A);
  static const Color darkTextPrimary = Color(0xFFF4F7F8);
  static const Color darkTextSecondary = Color(0xFFAAB7BE);

  // Phase 11 Light Study Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevatedSurface = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Primary Sky / Teal Brand Palette
  static const Color primary = Color(0xFF0797C8);
  static const Color primaryLight = Color(0xFF29B6E6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF173847);
  static const Color onPrimaryContainer = Color(0xFFBCE7FD);

  static const Color secondary = Color(0xFF26A69A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF163C38);
  static const Color onSecondaryContainer = Color(0xFFB2DFDB);

  static const Color tertiary = Color(0xFF5C6BC0);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF222B4C);
  static const Color onTertiaryContainer = Color(0xFFC5CAE9);

  // Functional Colors
  static const Color error = Color(0xFFE53935);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFF3F191B);
  static const Color onErrorContainer = Color(0xFFFFCDD2);

  static const Color success = Color(0xFF2BB673);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFF163826);
  static const Color onSuccessContainer = Color(0xFFC8E6C9);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFF3B2A10);
  static const Color onWarningContainer = Color(0xFFFFE082);

  // Surface & Neutral (Light)
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color onSurfaceVariantLight = Color(0xFF64748B);

  // Surface & Neutral (Dark)
  static const Color surfaceDark = Color(0xFF0B1115);
  static const Color onSurfaceDark = Color(0xFFF4F7F8);
  static const Color surfaceVariantDark = Color(0xFF151D22);
  static const Color onSurfaceVariantDark = Color(0xFFAAB7BE);
}

class AppStrings {
  static const String appName = 'LTO Exam Coach';
  static const String appTagline = 'Philippines Driving Exam Reviewer';
  static const String appVersion = '1.0.0';
  
  static const String disclaimerText = 
      'This is an independent educational reviewer and is not affiliated with, '
      'associated with, or endorsed by the Land Transportation Office (LTO) '
      'or any government agency of the Philippines.';

  static const String disclaimerShort =
      'Independent Educational Reviewer • Not affiliated with LTO';

  static const String examWarningNotice =
      'This application provides practice questions based on public road rules and safety concepts. '
      'High scores in this reviewer do not guarantee passing the official LTO theoretical examination.';
}

class AppCategories {
  static const String trafficRules = 'Traffic Rules';
  static const String roadSigns = 'Road Signs';
  static const String roadMarkings = 'Road Markings';
  static const String rightOfWay = 'Right of Way';
  static const String overtaking = 'Overtaking';
  static const String parking = 'Parking';
  static const String turning = 'Turning';
  static const String defensiveDriving = 'Defensive Driving';
  static const String vehicleBasics = 'Vehicle Basics';
  static const String safety = 'Safety';
  static const String expresswayRules = 'Expressway Rules';
  static const List<String> allCategories = [
    trafficRules,
    roadSigns,
    roadMarkings,
    rightOfWay,
    overtaking,
    parking,
    turning,
    defensiveDriving,
    vehicleBasics,
    safety,
    expresswayRules,
  ];
}

class AppVehicleTypes {
  static const String car = 'car';
  static const String motorcycle = 'motorcycle';
  static const String both = 'both';

  static const List<String> allTypes = [car, motorcycle, both];
}

class AppDifficulty {
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';

  static const List<String> allDifficulties = [easy, medium, hard];
}

class AppRadius {
  static const double sm = 6.0;
  static const double chip = 8.0;
  static const double button = 10.0;
  static const double card = 12.0;
  static const double dialog = 16.0;
  static const double pill = 16.0;
}

class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

