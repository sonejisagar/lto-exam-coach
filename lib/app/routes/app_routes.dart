import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../models/road_sign_model.dart';
import '../../screens/difficult_questions/difficult_questions_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/onboarding/vehicle_selection_screen.dart';
import '../../screens/review/question_review_screen.dart';
import '../../screens/road_signs/road_sign_detail_screen.dart';
import '../../screens/road_signs/road_signs_screen.dart';
import '../../screens/road_signs/sign_learning_screen.dart';
import '../../screens/settings/about_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/wrong_answers/wrong_answers_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String onboarding = '/onboarding';
  static const String vehicleSelect = '/vehicle-select';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String wrongAnswers = '/wrong-answers';
  static const String favorites = '/favorites';
  static const String difficult = '/difficult';
  static const String questionReview = '/question-review';
  static const String roadSigns = '/road-signs';
  static const String roadSignDetail = '/road-sign-detail';
  static const String signLearning = '/sign-learning';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case vehicleSelect:
        return MaterialPageRoute(
          builder: (_) => const VehicleSelectionScreen(isModal: true),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case AppRoutes.about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
        );
      case AppRoutes.wrongAnswers:
        return MaterialPageRoute(
          builder: (_) => const WrongAnswersScreen(),
        );
      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
        );
      case AppRoutes.difficult:
        return MaterialPageRoute(
          builder: (_) => const DifficultQuestionsScreen(),
        );
      case AppRoutes.questionReview:
        final question = settings.arguments as QuestionModel;
        return MaterialPageRoute(
          builder: (_) => QuestionReviewScreen(question: question),
        );
      case AppRoutes.roadSigns:
        return MaterialPageRoute(
          builder: (_) => const RoadSignsScreen(),
        );
      case AppRoutes.roadSignDetail:
        final sign = settings.arguments as RoadSignModel;
        return MaterialPageRoute(
          builder: (_) => RoadSignDetailScreen(sign: sign),
        );
      case AppRoutes.signLearning:
        return MaterialPageRoute(
          builder: (_) => const SignLearningScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
