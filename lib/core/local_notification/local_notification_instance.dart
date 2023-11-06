import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationInstance {
  factory LocalNotificationInstance() => _instance;

  LocalNotificationInstance._internal();
  static final _instance = LocalNotificationInstance._internal();

  static late final FlutterLocalNotificationsPlugin _notice;
  FlutterLocalNotificationsPlugin get notice => _notice;

  static void init() {
    _notice = FlutterLocalNotificationsPlugin();
  }
}
