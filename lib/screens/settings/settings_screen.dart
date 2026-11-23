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
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settingsTitle ?? 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GENERAL SECTION
            _buildSectionHeader(
              context,
              title: l10n?.sectionGeneral ?? 'GENERAL',
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    iconColor: AppColors.primary,
                    title: l10n?.settingLanguage ?? 'Language',
                    subtitle: 'Reviewer language / Wika',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: isDark ? 0.20 : 0.10),
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                          ),
                          child: Text(
                            settingsProvider.languageLabel,
                            style: TextStyle(
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                    onTap: () => _showLanguageSelectionDialog(context),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: AppColors.tertiary,
                    title: l10n?.settingDarkTheme ?? 'Dark Theme',
                    subtitle: l10n?.settingDarkThemeDesc ?? 'Toggle dark mode appearance',
                    trailing: Switch(
                      value: settingsProvider.themeMode == ThemeMode.dark,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        context.read<SettingsProvider>().setThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.notifications_active_rounded,
                    iconColor: AppColors.warning,
                    title: l10n?.settingDailyReminder ?? 'Daily Study Reminder',
                    subtitle: 'Get notified to practice daily at 7:00 PM',
                    trailing: Switch(
                      value: settingsProvider.dailyReminder,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        context.read<SettingsProvider>().setDailyReminder(val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // STUDY SECTION
            _buildSectionHeader(
              context,
              title: l10n?.sectionStudy ?? 'STUDY PREFERENCES',
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.directions_car_rounded,
                    iconColor: AppColors.secondary,
                    title: l10n?.settingVehicleCategory ?? 'Vehicle Category',
                    subtitle: settingsProvider.vehicleTypeLabel,
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    onTap: () => _showVehicleSelectionDialog(context),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.track_changes_rounded,
                    iconColor: AppColors.success,
                    title: l10n?.settingDailyGoal ?? 'Daily Practice Goal',
                    subtitle: l10n?.settingDailyGoalDesc(settingsProvider.dailyGoal) ??
                        '${settingsProvider.dailyGoal} Questions per day',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevatedSurface
                            : AppColors.lightElevatedSurface,
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: settingsProvider.dailyGoal,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_rounded, size: 20),
                        items: const [
                          DropdownMenuItem(
                            value: 10,
                            child: Text('10 Qs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          DropdownMenuItem(
                            value: 20,
                            child: Text('20 Qs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          DropdownMenuItem(
                            value: 30,
                            child: Text('30 Qs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            context.read<SettingsProvider>().setDailyGoal(val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ABOUT SECTION
            _buildSectionHeader(
              context,
              title: l10n?.sectionAbout ?? 'ABOUT & PRIVACY',
              color: AppColors.tertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.verified_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: l10n?.settingAppVersion ?? 'App Version',
                    subtitle: '1.0.0 (Build 9)',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.20 : 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                      child: const Text(
                        'Up to Date',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.primary,
                    title: 'About & Legal Disclaimer',
                    subtitle: 'App info, educational purpose & disclaimer',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: const Color(0xFF06B6D4),
                    title: 'Privacy Policy',
                    subtitle: 'Information on offline data and privacy',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    onTap: () => _showPrivacyPolicyDialog(context),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.ad_units_outlined,
                    iconColor: AppColors.warning,
                    title: 'Ad Privacy & Consent',
                    subtitle: 'Manage your advertising & consent preferences',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    onTap: () => _handleAdConsentOptions(context),
                  ),
                  _buildDivider(isDark),
                  _SettingsTile(
                    icon: Icons.restart_alt_rounded,
                    iconColor: AppColors.error,
                    title: 'Reset Study Data',
                    titleColor: AppColors.error,
                    subtitle: 'Clear practice history, mistakes, bookmarks & streak',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.error.withValues(alpha: 0.6),
                    ),
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

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 3.5,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontSize: 11.5,
          ),
        ),
      ],
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: titleColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
