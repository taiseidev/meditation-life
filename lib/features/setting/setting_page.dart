import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/utils/package_info_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/notification/notification_page.dart';
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
            title:
                Strings.accountId(FirebaseAuth.instance.currentUser?.uid ?? ''),
            subTitle: 'アカウント削除時に必要になります。',
            iconData: Icons.copy,
            callback: () {
              final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
              Clipboard.setData(ClipboardData(text: uid));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$uidをコピーしました'),
                ),
              );
            },
          ),
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
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextButton(
              onPressed: () => _launchUrl(Strings.dataDeleteUrl),
              child: const Text(
                'アカウント削除',
                style: TextStyle(color: Colors.red),
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
    this.subTitle,
    this.iconData = Icons.chevron_right,
    required this.callback,
  });

  final String title;
  final String? subTitle;
  final IconData iconData;
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
        subtitle: subTitle != null
            ? Text(
                subTitle!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox.shrink(),
        trailing: Icon(iconData),
        onTap: callback.withFeedback(),
      ),
    );
  }
}
