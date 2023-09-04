import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/shared/strings.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    ref.read(sharedPreferenceUtilProvider),
    FlutterLocalNotificationsPlugin(),
  ),
);

class NotificationService {
  NotificationService(this.prefs, this.localNotificationsPlugin);

  final SharePreferenceUtil prefs;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;

  Future<void> notificationSettings() async {
    await _requestNotificationPermission();
    await _scheduleDailyNotification();
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isIOS) {
      final iosImplementation =
          localNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final androidImplementation =
          localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }

  bool? _shouldSendNotification() =>
      prefs.getBool(SharedPreferenceKey.isNotificationEnabled);

  Future<void> _scheduleDailyNotification() async {
    if (_shouldSendNotification() == null || !_shouldSendNotification()!) {
      return;
    }

    await localNotificationsPlugin.zonedSchedule(
      0,
      Strings.appTitle,
      Strings.notificationMessage,
      _nextInstance(),
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
    );
  }

// 1回目に通知を飛ばす時間の作成
  tz.TZDateTime _nextInstance() {
    final notificationTimeList =
        prefs.getStringList(SharedPreferenceKey.notificationTimeList) ??
            ["08", "00"];

    final hour = int.parse(notificationTimeList[0]);
    final minute = int.parse(notificationTimeList[1]);

    // 現在のローカル時間を取得
    final now = tz.TZDateTime.now(tz.local);

    // 現在の日付の指定した時間を取得
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
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

// デバッグ用（5秒後に通知）
  // ignore: unused_element
  tz.TZDateTime _fiveSecondsLater() {
    var later = tz.TZDateTime.now(tz.local);

    later = later.add(const Duration(seconds: 5));
    return later;
  }
}
