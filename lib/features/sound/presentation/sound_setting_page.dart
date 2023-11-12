import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/shared_preference/preference_key_type.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/core/utils/vibration_utils.dart';

// TODO(taisei): 全体的にリファクタ
class SoundSettingPage extends HookConsumerWidget {
  const SoundSettingPage({super.key});

  static const defaultVibrationFlag = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final isEnabled = PreferenceKeyType.vibration.getBool();
      ref.read(vibrationStateProvider.notifier).toggle(isEnabled: isEnabled);
      return null;
    });

    return Scaffold(
      backgroundColor: Colors.white,
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
                value: ref.watch(vibrationStateProvider),
                onChanged: ({required bool value}) {
                  ref.read(vibrationUtilProvider).hapticFeedback();
                  ref
                      .read(vibrationStateProvider.notifier)
                      .toggle(isEnabled: value);
                  PreferenceKeyType.vibration.setBool(value);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = useState<double>(
      PreferenceKeyType.volume.getDouble(),
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
              ref.read(vibrationUtilProvider).hapticFeedback();
              volume.value = value;
            },
            onChangeEnd: (value) => PreferenceKeyType.volume.setDouble(value),
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
  final void Function({required bool value}) onChanged;

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
          onChanged: (value) => onChanged(value: value),
          activeColor: AppColor.secondary,
        ),
      ),
    );
  }
}
