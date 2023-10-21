import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vibration_utils.g.dart';

@riverpod
class VibrationState extends _$VibrationState {
  @override
  bool build() => true;

  void toggle({required bool isEnabled}) => state = isEnabled;
}

@Riverpod(keepAlive: true)
VibrationUtil vibrationUtil(VibrationUtilRef ref) => VibrationUtil(ref);

class VibrationUtil {
  VibrationUtil(this.ref);
  final VibrationUtilRef ref;

  Future<void> hapticFeedback() async {
    final isVibrationEnabled = ref.read(vibrationStateProvider);
    if (isVibrationEnabled) {
      await HapticFeedback.heavyImpact();
    }
  }
}
