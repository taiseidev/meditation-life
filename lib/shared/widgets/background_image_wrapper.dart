import 'package:flutter/material.dart';
import 'package:meditation_life/core/gen/assets.gen.dart';
import 'package:meditation_life/core/res/color.dart';

class BackgroundImageWrapper extends StatelessWidget {
  const BackgroundImageWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Gradient background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.background,
                AppColor.background.withOpacity(0.9),
              ],
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: -size.height * 0.1,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.accent.withOpacity(0.1),
            ),
          ),
        ),

        Positioned(
          bottom: -size.height * 0.05,
          left: -size.width * 0.3,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.secondary.withOpacity(0.08),
            ),
          ),
        ),

        // App logo with opacity
        Positioned(
          bottom: size.height * 0.05,
          right: size.width * 0.05,
          child: Opacity(
            opacity: 0.08,
            child: Image.asset(
              Assets.icons.appLogo.path,
              width: size.width * 0.3,
            ),
          ),
        ),

        // Main content
        SafeArea(child: child),
      ],
    );
  }
}
