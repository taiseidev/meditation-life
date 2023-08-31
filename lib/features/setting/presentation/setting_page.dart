import 'package:flutter/material.dart';
import 'package:meditation_life/features/notification/notification_page.dart';
import 'package:meditation_life/features/sound/presentation/sound_setting_page.dart';
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
        title: const Text('設定'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Scaffold(
        body: ListView(
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
            _SettingsTile(
              title: 'アプリケーション情報',
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.callback,
  });
  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: callback,
      ),
    );
  }
}
