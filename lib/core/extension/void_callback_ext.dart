import 'package:flutter/material.dart';
import 'package:meditation_life/core/utils/vibration.dart';

extension VoidCallbackExt on VoidCallback {
  VoidCallback withFeedback() {
    return () async {
      await Vibration.feedBack();
      this();
    };
  }
}

extension FunctionIntExt on dynamic Function(int) {
  dynamic Function(int) withFeedback() {
    return (int value) async {
      await Vibration.feedBack();
      return this(value);
    };
  }
}

extension FunctionBoolExt on void Function({required bool value}) {
  void Function({required bool value}) withFeedback() {
    return ({required bool value}) async {
      await Vibration.feedBack();
      this(value: value);
    };
  }
}

extension FunctionDoubleExt on void Function({required double value}) {
  void Function({required double value}) withFeedback() {
    return ({required double value}) async {
      await Vibration.feedBack();
      this(value: value);
    };
  }
}
