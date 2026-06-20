import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/name_repository.dart';
import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../../../core/constants.dart';
import '../../../core/store_links.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.mainGradientStart, AppColors.mainGradientEnd],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _SettingsTile(
                    icon: Icons.delete_sweep,
                    title: l10n.clearCache,
                    onTap: () => _confirmClear(context, l10n),
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy,
                    onTap: () =>
                        launchUrl(Uri.parse(AppConstants.privacyPolicyUrl)),
                  ),
                  _SettingsTile(
                    icon: Icons.star_rate,
                    title: l10n.reviewApp,
                    onTap: () => launchUrl(
                      StoreLinks.reviewUriFor(defaultTargetPlatform),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCache),
        content: Text(l10n.clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final nameRepository = context.read<NameRepository>();
    final userPreferencesRepository = context.read<UserPreferencesRepository>();
    await nameRepository.clearAll();
    await userPreferencesRepository.clearUserData();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cleared)));
    }
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.mainColor),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
