import 'package:meditation_life/core/shared_preference/shared_preference_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKeyType {
  volume,
  vibration,
  notificationTimeList,
  isNotificationEnabled
}

extension PreferenceKeyTypeEx on PreferenceKeyType {
  String get name => switch (this) {
        PreferenceKeyType.volume => 'volume',
        PreferenceKeyType.vibration => 'vibration',
        PreferenceKeyType.notificationTimeList => 'notificationTimeList',
        PreferenceKeyType.isNotificationEnabled => 'isNotificationEnabled',
      };

  SharedPreferences get _prefs => SharedPreferencesInstance().prefs;

  int getInt({int? defaultValue}) => _prefs.getInt(name) ?? defaultValue ?? 0;

  double getDouble({double? defaultValue}) =>
      _prefs.getDouble(name) ?? defaultValue ?? 1.0;

  bool getBool({bool? defaultValue}) =>
      SharedPreferencesInstance().prefs.getBool(name) ?? defaultValue ?? false;

  String getString({String? defaultValue}) =>
      _prefs.getString(name) ?? defaultValue ?? '';

  List<String> getStringList({List<String>? defaultValue}) =>
      _prefs.getStringList(name) ?? defaultValue ?? ['08', '00'];

  Future<void> setInt(int value) async => _prefs.setInt(name, value);

  Future<void> setDouble(double value) async => _prefs.setDouble(name, value);

  Future<void> setBool(bool value) async => _prefs.setBool(name, value);

  Future<void> setString(String value) async => _prefs.setString(name, value);

  Future<void> setStringList(List<String> values) async =>
      _prefs.setStringList(name, values);
}
