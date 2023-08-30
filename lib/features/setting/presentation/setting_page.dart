import 'package:flutter/material.dart';

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
        children: const [
          _SettingsTile(title: '通知設定'),
          _SettingsTile(title: '言語設定'),
          _SettingsTile(title: 'テーマ設定'),
          _SettingsTile(title: 'サウンド設定'),
          _SettingsTile(title: '利用規約'),
          _SettingsTile(title: 'プライバシーポリシー'),
          _SettingsTile(title: 'ヘルプ＆サポート'),
          _SettingsTile(title: 'アプリケーション情報'),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;

  const _SettingsTile({required this.title});

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
        onTap: () {
          // Navigate to the corresponding settings screen
        },
      ),
    );
  }
}
