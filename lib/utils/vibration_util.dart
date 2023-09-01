import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final vibrationEnabledProvider = StateProvider<bool>((_) => true);

final vibrationProvider = Provider<VibrationUtil>(
  (ref) => VibrationUtil(ref),
);

class VibrationUtil {
  VibrationUtil(this.ref);

  final ProviderRef ref;

  void impact(HapticFeedbackType type) {
    if (ref.watch(vibrationEnabledProvider)) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
      }
    }
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
}
