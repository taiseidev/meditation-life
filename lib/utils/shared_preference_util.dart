import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferenceProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

final sharedPreferenceUtilProvider = Provider<SharePreferenceUtil>(
  (ref) => SharePreferenceUtil(ref.read(sharedPreferenceProvider)),
);

class SharePreferenceUtil {
  SharePreferenceUtil(this._prefs);
  final SharedPreferences _prefs;

  Future<void> setDouble(SharedPreferenceKey key, double value) async =>
      await _prefs.setDouble(key.name, value);

  Future<void> setBool(SharedPreferenceKey key, bool value) async =>
      await _prefs.setBool(key.name, value);

  Future<void> setStringList(
          SharedPreferenceKey key, List<String> strings) async =>
      await _prefs.setStringList(key.name, strings);

  double? getDouble(SharedPreferenceKey key) => _prefs.getDouble(key.name);
  bool? getBool(SharedPreferenceKey key) => _prefs.getBool(key.name);
  List<String>? getStringList(SharedPreferenceKey key) =>
      _prefs.getStringList(key.name);
}

enum SharedPreferenceKey {
  volume,
  vibration,
  notificationTimeList,
  isNotificationEnabled
}
