import 'package:flutter/material.dart';

class SoundSettingPage extends StatefulWidget {
  const SoundSettingPage({super.key});

  @override
  SoundSettingPageState createState() => SoundSettingPageState();
}

class SoundSettingPageState extends State<SoundSettingPage> {
  double _volume = 0.5;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サウンド設定'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Row(
              children: [
                const Text(
                  '音量',
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Slider(
                  value: _volume,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                  activeColor: Colors.deepPurple,
                )
              ],
            ),
          ),
          _SettingsSwitchTile(
            title: 'バイブレーション',
            value: _vibration,
            onChanged: (value) {
              setState(() {
                _vibration = value;
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