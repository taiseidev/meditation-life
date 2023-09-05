import 'package:flutter/material.dart';

// ignore: avoid_implementing_value_types
class CommonAppBar extends StatelessWidget implements PreferredSize {
  const CommonAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  @override
  Widget get child => const SizedBox.shrink();

  @override
  Size get preferredSize => const Size(
        double.infinity,
        kToolbarHeight,
      );
}
