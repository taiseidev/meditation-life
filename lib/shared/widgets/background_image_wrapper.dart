import 'package:flutter/material.dart';
import 'package:meditation_life/core/gen/assets.gen.dart';

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
        OverflowBox(
          maxWidth: size.width * 1.5,
          child: Image.asset(
            Assets.icons.appLogo.path,
          ),
        ),
        child,
      ],
    );
  }
}
