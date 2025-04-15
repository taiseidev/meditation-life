import 'package:flutter/material.dart';
import 'package:meditation_life/core/utils/vibration.dart';

/// バイブレーションフィードバックを追加する拡張機能

/// VoidCallbackにバイブレーションフィードバックを追加
extension VoidCallbackExt on VoidCallback {
  /// バイブレーションフィードバックを追加したコールバックを返す
  VoidCallback withFeedback() {
    return () async {
      await Vibration.feedBack();
      this();
    };
  }
}

/// int引数を取る関数にバイブレーションフィードバックを追加
extension FunctionIntExt on Function(int) {
  /// バイブレーションフィードバックを追加した関数を返す
  Function(int) withFeedback() {
    return (int value) async {
      await Vibration.feedBack();
      this(value);
    };
  }
}

/// bool引数を取る関数にバイブレーションフィードバックを追加
extension FunctionBoolExt on void Function({required bool value}) {
  /// バイブレーションフィードバックを追加した関数を返す
  void Function({required bool value}) withFeedback() {
    return ({required bool value}) async {
      await Vibration.feedBack();
      this(value: value);
    };
  }
}

/// double引数を取る関数にバイブレーションフィードバックを追加
extension FunctionDoubleExt on void Function({required double value}) {
  /// バイブレーションフィードバックを追加した関数を返す
  void Function({required double value}) withFeedback() {
    return ({required double value}) async {
      await Vibration.feedBack();
      this(value: value);
    };
  }
}
