import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesのシングルトンインスタンスを提供するクラス
class SharedPreferencesInstance {
  /// シングルトンインスタンスを取得するファクトリコンストラクタ
  factory SharedPreferencesInstance() => _instance;

  /// プライベートコンストラクタ
  SharedPreferencesInstance._internal();

  /// シングルトンインスタンス
  static final _instance = SharedPreferencesInstance._internal();

  /// SharedPreferencesのインスタンス
  static late final SharedPreferences _prefs;

  /// SharedPreferencesのインスタンスを取得するゲッター
  SharedPreferences get prefs => _prefs;

  /// SharedPreferencesを初期化する
  ///
  /// アプリケーションの起動時に一度だけ呼び出す必要がある
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // 初期化に失敗した場合は、アプリケーションの動作に影響するため
      // 適切なエラーハンドリングが必要
      // 本番環境では適切なロギングやエラー報告を追加することを検討
      rethrow;
    }
  }
}
