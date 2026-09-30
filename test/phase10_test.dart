import 'package:flutter_test/flutter_test.dart';
import 'package:lto_exam_coach/config/ad_config.dart';
import 'package:lto_exam_coach/data/road_signs_data.dart';
import 'package:lto_exam_coach/services/question_repository.dart';

void main() {
  group('Phase 10 — Production Configuration & Release Readiness Tests', () {
    test('1. AdConfig isTestMode is enabled by default to prevent unauthorized production ad calls', () {
      expect(AdConfig.isTestMode, isTrue);
    });

    test('2. AdConfig hasValidProductionIds returns false when production IDs are not configured', () {
      expect(AdConfig.hasValidProductionIds, isFalse);
    });

    test('3. AdConfig validateProductionConfig identifies pending production credentials', () {
      final pending = AdConfig.validateProductionConfig();
      expect(pending, isNotEmpty);
      expect(pending.any((item) => item.contains('Banner')), isTrue);
      expect(pending.any((item) => item.contains('Interstitial')), isTrue);
      expect(pending.any((item) => item.contains('Privacy Policy')), isTrue);
    });

    test('4. AdConfig preserves official Google test ad unit IDs', () {
      expect(AdConfig.testAndroidBannerId, equals('ca-app-pub-3940256099942544/6300978111'));
      expect(AdConfig.testAndroidInterstitialId, equals('ca-app-pub-3940256099942544/1033173712'));
      expect(AdConfig.testIosBannerId, equals('ca-app-pub-3940256099942544/2934735716'));
      expect(AdConfig.testIosInterstitialId, equals('ca-app-pub-3940256099942544/4411468910'));
    });

    test('5. AdConfig privacyPolicyUrl is null without fake or dead URLs', () {
      expect(AdConfig.privacyPolicyUrl, isNull);
    });

    test('6. QuestionRepository loads all 150 practice questions offline with 0 validation errors', () {
      final repo = QuestionRepository();
      expect(repo.getAllQuestions().length, equals(150));
      expect(repo.validateDataset(), isEmpty);
    });

    test('7. RoadSignsData loads all 45 road signs completely offline', () {
      expect(RoadSignsData.allSigns.length, equals(45));
      for (final sign in RoadSignsData.allSigns) {
        expect(sign.id, isNotEmpty);
        expect(sign.name, isNotEmpty);
        expect(sign.category, isNotEmpty);
        expect(sign.meaning, isNotEmpty);
      }
    });

    test('8. Cooldown configuration guarantees minimum 180 seconds between interstitials', () {
      expect(AdConfig.minSecondsBetweenInterstitials, greaterThanOrEqualTo(180));
      expect(AdConfig.maxInterstitialsPerSession, equals(1));
    });
  });
}
