import 'package:meditation_life/core/shared_preference/shared_preference_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリケーションの設定キーを定義する列挙型
enum PreferenceKeyType {
  /// 音量設定
  volume,

  /// バイブレーション設定
  vibration,

  /// 通知時間リスト
  notificationTimeList,

  /// 通知有効フラグ
  isNotificationEnabled
}

/// PreferenceKeyTypeの拡張メソッド
extension PreferenceKeyTypeEx on PreferenceKeyType {
  /// キーの文字列表現を取得
  String get name => switch (this) {
        PreferenceKeyType.volume => 'volume',
        PreferenceKeyType.vibration => 'vibration',
        PreferenceKeyType.notificationTimeList => 'notificationTimeList',
        PreferenceKeyType.isNotificationEnabled => 'isNotificationEnabled',
      };

  /// SharedPreferencesのインスタンスを取得
  SharedPreferences get _prefs => SharedPreferencesInstance().prefs;

  /// 整数値を取得
  int getInt({int? defaultValue}) => _prefs.getInt(name) ?? defaultValue ?? 0;

  /// 浮動小数点値を取得
  double getDouble({double? defaultValue}) =>
      _prefs.getDouble(name) ?? defaultValue ?? 1.0;

  /// 真偽値を取得
  bool getBool({bool? defaultValue}) =>
      _prefs.getBool(name) ?? defaultValue ?? false;

  /// 文字列を取得
  String getString({String? defaultValue}) =>
      _prefs.getString(name) ?? defaultValue ?? '';

  /// 文字列リストを取得
  List<String> getStringList({List<String>? defaultValue}) {
    final List<String> defaultNotificationTime = ['08', '00'];

    // キーに応じてデフォルト値を設定
    final defaultValueForKey = switch (this) {
      PreferenceKeyType.notificationTimeList => defaultNotificationTime,
      _ => <String>[],
    };

    return _prefs.getStringList(name) ?? defaultValue ?? defaultValueForKey;
  }

  /// 整数値を設定
  Future<void> setInt(int value) async => _prefs.setInt(name, value);

  /// 浮動小数点値を設定
  Future<void> setDouble(double value) async => _prefs.setDouble(name, value);

  /// 真偽値を設定
  Future<void> setBool(bool value) async => _prefs.setBool(name, value);

  /// 文字列を設定
  Future<void> setString(String value) async => _prefs.setString(name, value);

  /// 文字列リストを設定
  Future<void> setStringList(List<String> values) async =>
      _prefs.setStringList(name, values);
}
