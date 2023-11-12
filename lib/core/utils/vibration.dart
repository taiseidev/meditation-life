import 'package:flutter/services.dart';
import 'package:meditation_life/core/shared_preference/preference_key_type.dart';

class Vibration {
  Vibration._();

  static Future<void> feedBack() async {
    final isVibrating = PreferenceKeyType.vibration.getBool();
    if (isVibrating) {
      await HapticFeedback.heavyImpact();
    }
  }
}
