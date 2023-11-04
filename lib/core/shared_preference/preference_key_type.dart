import 'package:meditation_life/core/shared_preference/shared_preference_instance.dart';

enum PreferenceKeyType {
  volume,
  vibration,
  notificationTimeList,
  isNotificationEnabled
}

extension PreferenceKeyTypeEx on PreferenceKeyType {
  String get name => switch (this) {
        PreferenceKeyType.volume => PreferenceKeyType.volume.name,
        PreferenceKeyType.vibration => PreferenceKeyType.vibration.name,
        PreferenceKeyType.notificationTimeList =>
          PreferenceKeyType.notificationTimeList.name,
        PreferenceKeyType.isNotificationEnabled =>
          PreferenceKeyType.isNotificationEnabled.name,
      };

  Future<bool> setInt(int value) async {
    return SharedPreferencesInstance().prefs.setInt(name, value);
  }

  int? getInt({int? defaultValue}) {
    if (SharedPreferencesInstance().prefs.containsKey(name)) {
      return SharedPreferencesInstance().prefs.getInt(name);
    } else {
      return defaultValue;
    }
  }

  Future<bool> setString(String value) async {
    return SharedPreferencesInstance().prefs.setString(name, value);
  }

  String? getString({String? defaultValue}) {
    if (SharedPreferencesInstance().prefs.containsKey(name)) {
      return SharedPreferencesInstance().prefs.getString(name);
    } else {
      return defaultValue;
    }
  }

  List<String> getStringList({String? defaultValue}) {
    return SharedPreferencesInstance().prefs.getStringList(name) ??
        ['08', '00'];
  }

  Future<bool> setStringList({required List<String> values}) async {
    return SharedPreferencesInstance().prefs.setStringList(name, []);
  }

  Future<bool> setBool({required bool setBool}) async {
    return SharedPreferencesInstance().prefs.setBool(name, setBool);
  }

  bool getBool() {
    return SharedPreferencesInstance().prefs.getBool(name) ?? false;
  }

  double getDouble() {
    return SharedPreferencesInstance().prefs.getDouble(name) ?? 1.0;
  }

  Future<void> setDouble(double value) async =>
      SharedPreferencesInstance().prefs.setDouble(name, value);
}
