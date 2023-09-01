import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/utils/vibration_util.dart';

class SoundSettingPage extends StatefulWidget {
  const SoundSettingPage({super.key});

  @override
  SoundSettingPageState createState() => SoundSettingPageState();
}

class SoundSettingPageState extends State<SoundSettingPage> {
  double _volume = 0.5;
  final bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'サウンド設定',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, child) {
                    return Slider(
                      value: _volume,
                      onChanged: (value) {
                        ref
                            .read(vibrationProvider)
                            .impact(HapticFeedbackType.lightImpact);
                        setState(() {
                          _volume = value;
                        });
                      },
                      activeColor: const Color(0xff00a497),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return _SettingsSwitchTile(
                title: 'バイブレーション',
                value: ref.watch(vibrationEnabledProvider),
                onChanged: (value) {
                  ref
                      .read(vibrationProvider)
                      .impact(HapticFeedbackType.mediumImpact);
                  ref
                      .read(vibrationEnabledProvider.notifier)
                      .update((state) => state = value);
                },
              );
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff00a497),
        ),
      ),
    );
  }
}
