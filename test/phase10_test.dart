import 'package:flutter_test/flutter_test.dart';
import 'package:lto_exam_coach/config/ad_config.dart';
import 'package:lto_exam_coach/data/road_signs_data.dart';
import 'package:lto_exam_coach/services/firebase_service.dart';
import 'package:lto_exam_coach/services/question_repository.dart';

void main() {
  group('Phase 10 — Production Configuration & Release Readiness Tests', () {
    test('1. AdConfig production readiness validates that all production ad unit IDs are configured', () {
      expect(AdConfig.hasValidProductionIds, isTrue);
      expect(AdConfig.validateProductionConfig(), isEmpty);
    });

    test('2. AdConfig production IDs contain valid AdMob unit IDs', () {
      expect(AdConfig.prodAndroidBannerId, startsWith('ca-app-pub-'));
      expect(AdConfig.prodAndroidInterstitialId, startsWith('ca-app-pub-'));
      expect(AdConfig.prodAndroidAppOpenId, equals('ca-app-pub-4523328156597896/7213325272'));
    });

    test('3. AdConfig preserves official Google test ad unit IDs including App Open', () {
      expect(AdConfig.testAndroidBannerId, equals('ca-app-pub-3940256099942544/6300978111'));
      expect(AdConfig.testAndroidInterstitialId, equals('ca-app-pub-3940256099942544/1033173712'));
      expect(AdConfig.testAndroidAppOpenId, equals('ca-app-pub-3940256099942544/9257395921'));
      expect(AdConfig.testIosBannerId, equals('ca-app-pub-3940256099942544/2934735716'));
      expect(AdConfig.testIosInterstitialId, equals('ca-app-pub-3940256099942544/4411468910'));
      expect(AdConfig.testIosAppOpenId, equals('ca-app-pub-3940256099942544/5575463023'));
    });

    test('5. AdConfig privacyPolicyUrl is a verified production HTTPS URL', () {
      expect(AdConfig.privacyPolicyUrl, equals('https://sonejisagar.github.io/lto-exam-coach/'));
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

    test('9. FirebaseService defaults are safe and adsEnabled is true by default', () {
      expect(FirebaseService.instance.adsEnabled, isTrue);
      expect(AdConfig.areAdsEnabled, isTrue);
      expect(FirebaseService.instance.interstitialCooldownSeconds, equals(180));
    });
  });
}
