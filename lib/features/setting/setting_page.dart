import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/utils/package_info_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/core/utils/vibration_utils.dart';
import 'package:meditation_life/features/notification/notification_page.dart';
import 'package:meditation_life/features/sound/presentation/sound_setting_page.dart';
import 'package:meditation_life/shared/widgets/common_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: const CommonAppBar(title: Strings.settingPageTitle),
      body: Column(
        children: [
          _SettingsTile(
            title: Strings.notificationSettingLabel,
            callback: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const NotificationPage(),
              ),
            ),
          ),
          _SettingsTile(
            title: Strings.soundSettingLabel,
            callback: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SoundSettingPage(),
              ),
            ),
          ),
          _SettingsTile(
            title: Strings.termsOfServiceLabel,
            callback: () => _launchUrl(Strings.termsOfServiceUrl),
          ),
          _SettingsTile(
            title: Strings.privacyPolicyLabel,
            callback: () => _launchUrl(Strings.privacyPolicyUrl),
          ),
          _SettingsTile(
            title: Strings.contactLabel,
            callback: () => _launchUrl(Strings.contactUrl),
          ),
          Stack(
            children: [
              _SettingsTile(
                title: '広告非表示',
                callback: () {},
              ),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.3),
                  child: const Text(
                    'Coming Soon...',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Align(
              child: Consumer(
                builder: (context, ref, child) => Text(
                  Strings.appVersion(
                    PackageInfoInstance.version,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends ConsumerWidget {
  const _SettingsTile({
    required this.title,
    required this.callback,
  });

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: () {
          ref.read(vibrationUtilProvider).hapticFeedback();
          callback();
        },
      ),
    );
  }
}
