import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/shared/res/color.dart';
import 'package:meditation_life/shared/strings.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';
import 'package:meditation_life/utils/vibration_util.dart';

// TODO: 全体的にリファクタ
class SoundSettingPage extends HookConsumerWidget {
  const SoundSettingPage({super.key});

  static const defaultVibrationFlag = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() async {
        final vibrationEnabled = ref
                .read(sharedPreferenceUtilProvider)
                .getBool(SharedPreferenceKey.vibration) ??
            defaultVibrationFlag;
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
          Strings.soundSettingLabel,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const _SliderTile(),
          Consumer(
            builder: (context, ref, child) {
              return _SettingSwitchTile(
                title: Strings.vibrationLabel,
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

class _SliderTile extends HookConsumerWidget {
  const _SliderTile();

  static const defaultVolume = 1.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = useState<double>(
      ref
              .read(sharedPreferenceUtilProvider)
              .getDouble(SharedPreferenceKey.volume) ??
          defaultVolume,
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Row(
        children: [
          const Text(
            Strings.volumeLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Slider(
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
            activeColor: AppColor.secondary,
          ),
        ],
      ),
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  const _SettingSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          activeColor: AppColor.secondary,
        ),
      ),
    );
  }
}
