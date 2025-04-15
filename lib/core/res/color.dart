import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();

  // Main colors
  static const primary = Color(0xFF2D3047);      // Deep blue-gray
  static const secondary = Color(0xFF7A9E9F);    // Teal
  static const accent = Color(0xFFB8D8D8);       // Light teal

  // Additional palette
  static const background = Color(0xFFF5F5F5);   // Light gray background
  static const cardBackground = Color(0xFFFFFFFF); // White card background
  static const textPrimary = Color(0xFF2D3047);  // Dark text
  static const textSecondary = Color(0xFF7A8C98); // Medium gray text
  static const highlight = Color(0xFFEEB462);    // Warm highlight
  static const error = Color(0xFFE56B6F);        // Soft red for errors

  // Gradients
  static const gradientStart = Color(0xFF7A9E9F);
  static const gradientEnd = Color(0xFF2D3047);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Meditation-specific colors
  static const meditationBlue = Color(0xFF6E8387);  // Calming blue
  static const meditationPurple = Color(0xFF9B8EA9); // Soft purple
  static const meditationGreen = Color(0xFF8FB9AA);  // Peaceful green
}
