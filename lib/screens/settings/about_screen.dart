import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/ad_config.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/disclaimer_banner.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Logo / Icon Concept Badge
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.appTagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Chip(
              label: const Text('Version 1.0.0'),
              visualDensity: VisualDensity.compact,
              backgroundColor: colorScheme.surfaceContainerHigh,
            ),
            const SizedBox(height: 24),

            // Prominent Legal Disclaimer
            const DisclaimerBanner(compact: false),
            const SizedBox(height: 20),

            // App Description & Mission
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purpose & Features',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'LTO Exam Coach is a self-paced study companion designed for aspiring drivers in the Philippines. '
                    'It includes 150 original practice questions, visual road sign guides, realistic mock tests, and wrong answer tracking to help you prepare effectively.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Privacy Policy Card
            CustomCard(
              onTap: () {
                _showPrivacyPolicyDialog(context);
              },
              child: Row(
                children: [
                  Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Privacy Policy',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Privacy Policy'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Offline Data Storage',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'LTO Exam Coach is designed as an offline-first educational tool. Your questions, bookmarks, practice history, wrong answers, study streak, and mock test scores are stored locally on your device. We do not transmit or store your study progress on external servers.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Advertising & Analytics',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'This app displays non-intrusive advertisements supported by Google AdMob. Google AdMob and its advertising partners may collect device identifiers and usage metrics to deliver and measure ad performance in accordance with Google policies.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Production Policy Notice',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                AdConfig.privacyPolicyUrl.isNotEmpty &&
                        AdConfig.privacyPolicyUrl.startsWith('https://')
                    ? 'Our complete online privacy policy can be viewed at: ${AdConfig.privacyPolicyUrl}'
                    : 'The production Privacy Policy webpage source is included in docs/privacy_policy.html. Deploy it to a public HTTPS host and configure AdConfig.privacyPolicyUrl before Google Play Store submission.',
              ),
            ],
          ),
        ),
        actions: [
          if (AdConfig.privacyPolicyUrl.isNotEmpty &&
              AdConfig.privacyPolicyUrl.startsWith('https://'))
            TextButton.icon(
              icon: const Icon(Icons.open_in_browser_rounded, size: 18),
              label: const Text('Open Online Policy'),
              onPressed: () {
                final uri = Uri.parse(AdConfig.privacyPolicyUrl);
                launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
