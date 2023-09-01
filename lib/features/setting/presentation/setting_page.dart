import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/notification/notification_page.dart';
import 'package:meditation_life/features/sound/presentation/sound_setting_page.dart';
import 'package:meditation_life/shared/package_info_util.dart';
import 'package:meditation_life/utils/vibration_util.dart';
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
      appBar: AppBar(
        title: const Text(
          '設定',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Scaffold(
        body: Column(
          children: [
            _SettingsTile(
              title: '通知設定',
              callback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ),
            ),
            _SettingsTile(
              title: 'サウンド設定',
              callback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SoundSettingPage(),
                ),
              ),
            ),
            _SettingsTile(
              title: '利用規約',
              callback: () => _launchUrl(
                "https://ionian-earthworm-71d.notion.site/4b44e3fb3e5a4133875b18cab6e75e07?pvs=4",
              ),
            ),
            _SettingsTile(
              title: 'プライバシーポリシー',
              callback: () => _launchUrl(
                "https://ionian-earthworm-71d.notion.site/67d9545c307748fc8e0bdd67ed852900?pvs=4",
              ),
            ),
            _SettingsTile(
              title: 'お問い合わせ',
              callback: () => _launchUrl("https://forms.gle/zbWgULaGxh46jfyF7"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Align(
                child: Consumer(
                  builder: (context, ref, child) => Text(
                    "ver ${ref.read(packageInfoUtilProvider).version}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return Container(
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
          vertical: 10,
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
          ref.read(vibrationProvider).impact(HapticFeedbackType.lightImpact);
          callback();
        },
      ),
    );
  }
}
