import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/shared/res/color.dart';
import 'package:meditation_life/shared/strings.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';

class NotificationPage extends HookConsumerWidget {
  const NotificationPage({super.key});

  static const defaultTimeList = ["08", "00"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationEnabled = useState<bool>(true);
    final notificationTimeList = useState<List<String>>(defaultTimeList);

    useEffect(() {
      Future(() async {
        isNotificationEnabled.value = ref
                .read(sharedPreferenceUtilProvider)
                .getBool(SharedPreferenceKey.isNotificationEnabled) ??
            true;
        notificationTimeList.value =
            ref.read(sharedPreferenceUtilProvider).getStringList(
                      SharedPreferenceKey.notificationTimeList,
                    ) ??
                defaultTimeList;
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
          Strings.notificationSettingLabel,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _SettingsSwitchTile(
            title: Strings.notificationToggleLabel,
            value: isNotificationEnabled.value,
            onChanged: (value) {
              isNotificationEnabled.value = value;
              ref
                  .read(sharedPreferenceUtilProvider)
                  .setBool(SharedPreferenceKey.isNotificationEnabled, value);
            },
          ),
          _NotificationDateTile(
            title: Strings.notificationTimeLabel,
            values: notificationTimeList.value,
            onChanged: (value) {
              // TODO:リファクタ
              final hour = value.hour.toString().padLeft(2, '0');
              final minute = value.minute.toString().padLeft(2, '0');
              notificationTimeList.value = [hour, minute];
              ref.read(sharedPreferenceUtilProvider).setStringList(
                  SharedPreferenceKey.notificationTimeList, [hour, minute]);
            },
          )
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
          activeColor: AppColor.secondary,
        ),
      ),
    );
  }
}

class _NotificationDateTile extends StatelessWidget {
  const _NotificationDateTile({
    required this.title,
    required this.values,
    required this.onChanged,
  });

  final String title;
  final List<String> values;
  final Function(Time) onChanged;

  int get hour => int.parse(values[0]);
  int get minute => int.parse(values[1]);

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
        trailing: GestureDetector(
          onTap: () => Navigator.of(context).push(
            showPicker(
              context: context,
              value: Time(hour: hour, minute: minute),
              sunrise: const TimeOfDay(hour: 6, minute: 0),
              sunset: const TimeOfDay(hour: 18, minute: 0),
              duskSpanInMinutes: 120,
              accentColor: AppColor.secondary,
              okText: Strings.updateLabel,
              cancelText: Strings.closeLabel,
              okStyle: const TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.bold,
              ),
              cancelStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              onChange: onChanged,
            ),
          ),
          child: Text(
            "${values[0]}：${values[1]}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
