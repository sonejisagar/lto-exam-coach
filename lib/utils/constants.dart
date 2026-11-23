import 'package:flutter/material.dart';

class AppColors {
  // Phase 12 Elevated Dark Automotive / Oceanic Study Palette
  static const Color darkBackground = Color(0xFF090E15);
  static const Color darkSurface = Color(0xFF111923);
  static const Color darkElevatedSurface = Color(0xFF182330);
  static const Color darkBorder = Color(0xFF223242);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Phase 12 Clean Porcelain Light Study Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevatedSurface = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Vibrant Electric Sky Brand Palette (Modern LTO Driving Tech)
  static const Color primary = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0369A1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0C2B3E);
  static const Color onPrimaryContainer = Color(0xFFBAE6FD);

  // Teal / Cyan Secondary Accent
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryLight = Color(0xFF2DD4BF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF103633);
  static const Color onSecondaryContainer = Color(0xFF99F6E4);

  // Indigo / Royal Tertiary Accent
  static const Color tertiary = Color(0xFF6366F1);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF1E1B4B);
  static const Color onTertiaryContainer = Color(0xFFC7D2FE);

  // High-Vibrancy Functional Accents
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFF451419);
  static const Color onErrorContainer = Color(0xFFFECDD3);

  static const Color success = Color(0xFF10B981);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFF0D3728);
  static const Color onSuccessContainer = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFF3F2606);
  static const Color onWarningContainer = Color(0xFFFDE68A);

  // Surface & Neutral (Light)
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color onSurfaceVariantLight = Color(0xFF64748B);

  // Surface & Neutral (Dark)
  static const Color surfaceDark = Color(0xFF090E15);
  static const Color onSurfaceDark = Color(0xFFF8FAFC);
  static const Color surfaceVariantDark = Color(0xFF111923);
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF38BDF8)],
  );

  static const LinearGradient primaryAccent = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
  );

  static const LinearGradient amber = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
  );

  static const LinearGradient emerald = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
  );

  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF131D28), Color(0xFF0E1620)],
  );

  static const LinearGradient darkCardGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF182635), Color(0xFF101923)],
  );

  static const LinearGradient lightCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  static const LinearGradient glassNavDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xF0131B24), Color(0xF50D131B)],
  );

  static const LinearGradient glassNavLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xF8FFFFFF), Color(0xF2F8FAFC)],
  );
}

class AppShadows {
  static List<BoxShadow> get cardLight => [
        const BoxShadow(
          color: Color(0x080F172A),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardDark => [
        const BoxShadow(
          color: Color(0x28000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get floatingNavLight => [
        const BoxShadow(
          color: Color(0x140284C7),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
        const BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get floatingNavDark => [
        const BoxShadow(
          color: Color(0x40000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get primaryGlow => [
        const BoxShadow(
          color: Color(0x250284C7),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ];
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
  static const double sm = 8.0;
  static const double chip = 10.0;
  static const double button = 14.0;
  static const double card = 16.0;
  static const double dialog = 20.0;
  static const double pill = 28.0;
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

