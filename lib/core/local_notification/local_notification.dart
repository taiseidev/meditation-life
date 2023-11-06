import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_life/core/shared_preference/preference_key_type.dart';
import 'package:meditation_life/shared/strings.dart';
import 'package:meditation_life/utils/local_time_zone_util.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class LocalNotification {
  factory LocalNotification() => _instance;

  LocalNotification._internal();
  static final _instance = LocalNotification._internal();

  static late final FlutterLocalNotificationsPlugin _notice;
  FlutterLocalNotificationsPlugin get notice => _notice;

  static void init() {
    _notice = FlutterLocalNotificationsPlugin();
  }

  Future<void> localNotificationSetting() async => Future.wait(
        [
          _requestNotificationPermission(),
          _scheduleDailyNotification(),
        ],
      );

  Future<void> _requestNotificationPermission() async {
    if (Platform.isIOS) {
      final iosImplementation = notice.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    if (Platform.isAndroid) {
      final androidImplementation =
          notice.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }

  Future<void> _scheduleDailyNotification() async {
    if (!PreferenceKeyType.isNotificationEnabled.getBool()) {
      return;
    }

    final timezone = _nextInstance(
      tz.getLocation(LocalTimeZoneUtil.localTimeZone),
    );

    await notice.zonedSchedule(
      0,
      Strings.appTitle,
      Strings.notificationMessage,
      timezone,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '',
          '',
          channelDescription: '',
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // 毎日通知を送信する様に設定
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

// 1回目に通知を飛ばす時間の作成
  tz.TZDateTime _nextInstance(Location region) {
    final notificationTimeList =
        PreferenceKeyType.notificationTimeList.getStringList();

    final hour = int.parse(notificationTimeList.first);
    final minute = int.parse(notificationTimeList.last);

    // 現在のローカル時間を取得
    final now = tz.TZDateTime.now(region);

    // 現在の日付の指定した時間を取得
    var scheduledDate = tz.TZDateTime(
      region,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // スケジュールされた時刻が現在時刻よりも過去の場合
    // 明日に通知設定
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

// デバッグ用（5秒後に通知）
  // ignore: unused_element
  tz.TZDateTime _fiveSecondsLater(Location region) =>
      tz.TZDateTime.now(region).add(
        const Duration(seconds: 5),
      );
}
