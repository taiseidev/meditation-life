import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
}

final vibrationEnabledProvider = StateProvider<bool>((_) => true);

final vibrationProvider = Provider<VibrationUtil>(
  VibrationUtil.new,
);

class VibrationUtil {
  VibrationUtil(this.ref);

  final ProviderRef<dynamic> ref;

  void impact(HapticFeedbackType type) {
    if (ref.watch(vibrationEnabledProvider)) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
      }
    }
  }
}
