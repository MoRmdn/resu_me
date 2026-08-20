import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Mono, uppercase, wide-tracked section label — e.g. "01 / About".
class Eyebrow extends StatelessWidget {
  final String text;
  final Color? color;

  const Eyebrow(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        letterSpacing: 2.2,
        color: color ?? AppColors.bone45,
      ),
    );
  }
}
