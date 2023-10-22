import 'package:flutter_timezone/flutter_timezone.dart';

class LocalTimeZoneUtil {
  factory LocalTimeZoneUtil() => _instance;
  LocalTimeZoneUtil._();

  static late String localTimeZone;
  static final LocalTimeZoneUtil _instance = LocalTimeZoneUtil._();

  static Future<void> init() async {
    localTimeZone = await FlutterTimezone.getLocalTimezone();
  }
}
