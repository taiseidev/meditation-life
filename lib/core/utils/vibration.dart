import 'package:flutter/services.dart';
import 'package:meditation_life/core/shared_preference/preference_key_type.dart';

/// バイブレーション機能を提供するユーティリティクラス
class Vibration {
  // プライベートコンストラクタでインスタンス化を防止
  Vibration._();

  /// ユーザー設定に基づいてバイブレーションフィードバックを提供する
  ///
  /// ユーザーがバイブレーションを無効にしている場合は何も行わない
  static Future<void> feedBack() async {
    try {
      final isVibrating = PreferenceKeyType.vibration.getBool();
      if (isVibrating) {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // バイブレーションの失敗はユーザー体験に重大な影響を与えないため、
      // エラーをサイレントに処理する
      // 本番環境では適切なロギングを追加することを検討
    }
  }
}
