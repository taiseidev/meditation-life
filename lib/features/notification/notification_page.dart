import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _inAppNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          _SettingsSwitchTile(
            title: 'プッシュ通知',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          _SettingsSwitchTile(
            title: 'メール通知',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          _SettingsSwitchTile(
            title: 'アプリ内通知',
            value: _inAppNotifications,
            onChanged: (value) {
              setState(() {
                _inAppNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

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
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
