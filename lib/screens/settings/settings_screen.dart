import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/routes/app_routes.dart';
import '../../config/ad_config.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/ad_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/disclaimer_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settingsTitle ?? 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GENERAL SECTION
            _buildSectionHeader(context, l10n?.sectionGeneral ?? 'GENERAL'),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: Text(l10n?.settingLanguage ?? 'Language'),
                    subtitle: const Text('Reviewer language / Wika'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settingsProvider.languageLabel,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: () => _showLanguageSelectionDialog(context),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n?.settingDarkTheme ?? 'Dark Theme'),
                    subtitle: Text(l10n?.settingDarkThemeDesc ?? 'Toggle app dark mode appearance'),
                    secondary: const Icon(Icons.dark_mode_rounded),
                    value: settingsProvider.themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      context.read<SettingsProvider>().setThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n?.settingDailyReminder ?? 'Daily Study Reminder'),
                    subtitle: const Text('Get notified to practice daily at 7:00 PM'),
                    secondary: const Icon(Icons.notifications_active_rounded),
                    value: settingsProvider.dailyReminder,
                    onChanged: (val) {
                      context.read<SettingsProvider>().setDailyReminder(val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // STUDY SECTION
            _buildSectionHeader(context, l10n?.sectionStudy ?? 'STUDY'),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.directions_car_rounded),
                    title: Text(l10n?.settingVehicleCategory ?? 'Vehicle Category'),
                    subtitle: Text(settingsProvider.vehicleTypeLabel),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showVehicleSelectionDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.track_changes_rounded),
                    title: Text(l10n?.settingDailyGoal ?? 'Daily Practice Goal'),
                    subtitle: Text(
                      l10n?.settingDailyGoalDesc(settingsProvider.dailyGoal) ??
                          '${settingsProvider.dailyGoal} Questions per day',
                    ),
                    trailing: DropdownButton<int>(
                      value: settingsProvider.dailyGoal,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 10, child: Text('10 Qs')),
                        DropdownMenuItem(value: 20, child: Text('20 Qs')),
                        DropdownMenuItem(value: 30, child: Text('30 Qs')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsProvider>().setDailyGoal(val);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ABOUT SECTION
            _buildSectionHeader(context, l10n?.sectionAbout ?? 'ABOUT'),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_rounded),
                    title: Text(l10n?.settingAppVersion ?? 'App Version'),
                    subtitle: const Text('1.0.0 (Build 1)'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('About & Legal Disclaimer'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('Information on offline data and privacy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _handlePrivacyPolicyTap(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.ad_units_outlined),
                    title: const Text('Ad Privacy & Consent'),
                    subtitle: const Text('Manage your advertising & consent preferences'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _handleAdConsentOptions(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.restart_alt_rounded, color: AppColors.error),
                    title: const Text(
                      'Reset Study Data',
                      style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Clear practice history, wrong answers, bookmarks, mock tests, and streak'),
                    onTap: () {
                      _showResetConfirmationDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const DisclaimerBanner(compact: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Language'),
        content: RadioGroup<String>(
          groupValue: settingsProvider.languageCode,
          onChanged: (val) {
            if (val != null) {
              settingsProvider.setLanguageCode(val);
              Navigator.pop(ctx);
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('English'),
                subtitle: Text('Canonical original reviewer content'),
                value: 'en',
              ),
              RadioListTile<String>(
                title: Text('Filipino'),
                subtitle: Text('Localized study reviewer version'),
                value: 'fil',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVehicleSelectionDialog(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vehicle Category'),
        content: RadioGroup<String>(
          groupValue: settingsProvider.vehicleType,
          onChanged: (val) {
            if (val != null) {
              settingsProvider.setVehicleType(val);
              Navigator.pop(ctx);
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Car (Non-Professional / Light Vehicle)'),
                value: 'car',
              ),
              RadioListTile<String>(
                title: Text('Motorcycle (Two-Wheeler)'),
                value: 'motorcycle',
              ),
              RadioListTile<String>(
                title: Text('Both Car & Motorcycle'),
                value: 'both',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Study Data?'),
        content: const Text(
          'This will permanently reset all your offline study progress on this device, including practice question attempts, study streak, bookmarks, wrong answer bank, and mock exam history.\n\nYour app preferences (language, theme mode, and vehicle preference) will be preserved.\n\nNote: This only affects local offline study data. It does not reset third-party ad personalization or consent settings, which can be managed separately under Ad Privacy Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              ProgressProvider? progressProvider;
              try {
                progressProvider = context.read<ProgressProvider>();
              } catch (_) {}
              final settingsProvider = context.read<SettingsProvider>();

              Navigator.pop(ctx);
              await settingsProvider.resetAllStudyData();
              if (progressProvider != null) {
                progressProvider.refreshProgress();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All local study data and progress have been reset.')),
                );
              }
            },
            child: const Text('Reset Study Data'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrivacyPolicyTap(BuildContext context) async {
    final url = AdConfig.privacyPolicyUrl;
    if (url != null && url.isNotEmpty && url.startsWith('https://')) {
      final uri = Uri.parse(url);
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) return;
      } catch (_) {
        // Fallback to dialog if external launch is unavailable
      }
    }
    if (context.mounted) {
      _showPrivacyPolicyDialog(context);
    }
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
                AdConfig.privacyPolicyUrl != null &&
                        AdConfig.privacyPolicyUrl!.isNotEmpty &&
                        AdConfig.privacyPolicyUrl!.startsWith('https://')
                    ? 'Our complete online privacy policy can be viewed at: ${AdConfig.privacyPolicyUrl}'
                    : 'The production Privacy Policy webpage source is included in docs/privacy_policy.html. Deploy it to a public HTTPS host and configure AdConfig.privacyPolicyUrl before Google Play Store submission.',
              ),
            ],
          ),
        ),
        actions: [
          if (AdConfig.privacyPolicyUrl != null &&
              AdConfig.privacyPolicyUrl!.isNotEmpty &&
              AdConfig.privacyPolicyUrl!.startsWith('https://'))
            TextButton.icon(
              icon: const Icon(Icons.open_in_browser_rounded, size: 18),
              label: const Text('Open Online Policy'),
              onPressed: () {
                final uri = Uri.parse(AdConfig.privacyPolicyUrl!);
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

  void _handleAdConsentOptions(BuildContext context) {
    AdService.instance.showPrivacyOptionsForm(
      onComplete: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Advertising choices and consent updated.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}

