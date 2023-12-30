import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_life/core/shared_preference/preference_key_type.dart';
import 'package:meditation_life/core/utils/local_time_zone_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class LocalNotification {
  factory LocalNotification() => _instance;
  LocalNotification._internal();

  static final LocalNotification _instance = LocalNotification._internal();

  final FlutterLocalNotificationsPlugin _notice =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notice => _notice;

  Future<void> localNotificationSetting() async {
    await _requestNotificationPermission();
    await _scheduleDailyNotification();
  }

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
      // 通知をキャンセル
      await notice.cancel(0);
      return;
    }

    await notice.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final timezone = _nextInstance(
      tz.getLocation(LocalTimeZoneUtil.localTimeZone),
    );

    const androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await notice.zonedSchedule(
      0,
      Strings.appTitle,
      Strings.notificationMessage,
      timezone,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance(Location region) {
    final notificationTimeList =
        PreferenceKeyType.notificationTimeList.getStringList();

    final hour = int.parse(notificationTimeList.first);
    final minute = int.parse(notificationTimeList.last);

    final now = tz.TZDateTime.now(region);

    var scheduledDate = tz.TZDateTime(
      region,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
