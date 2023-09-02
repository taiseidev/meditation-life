import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';
import 'package:meditation_life/utils/vibration_util.dart';

class SoundSettingPage extends HookConsumerWidget {
  const SoundSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = useState<double>(0.0);
    useEffect(() {
      Future(() async {
        volume.value = ref
                .read(sharedPreferenceUtilProvider)
                .getDouble(SharedPreferenceKey.volume) ??
            1.0;
        final vibrationEnabled = ref
                .read(sharedPreferenceUtilProvider)
                .getBool(SharedPreferenceKey.vibration) ??
            true;
        ref
            .read(vibrationEnabledProvider.notifier)
            .update((state) => state = vibrationEnabled);
      });
      return null;
    });
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
                      value: volume.value,
                      onChanged: (value) {
                        ref
                            .read(vibrationProvider)
                            .impact(HapticFeedbackType.lightImpact);
                        volume.value = value;
                      },
                      onChangeEnd: (value) {
                        ref
                            .read(sharedPreferenceUtilProvider)
                            .setDouble(SharedPreferenceKey.volume, value);
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
                  ref
                      .read(sharedPreferenceUtilProvider)
                      .setBool(SharedPreferenceKey.vibration, value);
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
