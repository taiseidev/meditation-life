import 'package:flutter/material.dart';
import 'package:meditation_life/features/notification/notification_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Colors.deepPurple,
      ),
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
            callback: () {},
          ),
          _SettingsTile(
            title: '利用規約',
            callback: () {},
          ),
          _SettingsTile(
            title: 'プライバシーポリシー',
            callback: () {},
          ),
          _SettingsTile(
            title: 'お問い合わせ',
            callback: () {},
          ),
          _SettingsTile(
            title: 'アプリケーション情報',
            callback: () {},
          ),
        ],
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
