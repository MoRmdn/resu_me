import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// The composed M — a single folded stroke, four folds. The right half
/// (the "second layer") renders in copper. See LOGO.md for the full spec.
class MoRmdnMark extends StatelessWidget {
  final double size;
  final Color boneColor;
  final Color copperColor;

  const MoRmdnMark({
    super.key,
    this.size = 26,
    this.boneColor = AppColors.bone,
    this.copperColor = AppColors.copper,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MarkPainter(boneColor: boneColor, copperColor: copperColor),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final Color boneColor;
  final Color copperColor;

  _MarkPainter({required this.boneColor, required this.copperColor});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48;
    final strokeWidth = 4.4 * scale;

    final boneStyle = Paint()
      ..color = boneColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    final copperStyle = Paint()
      ..color = copperColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    Offset p(double x, double y) => Offset(x * scale, y * scale);

    final bonePath = Path()
      ..moveTo(p(6, 39).dx, p(6, 39).dy)
      ..lineTo(p(17, 9).dx, p(17, 9).dy)
      ..lineTo(p(24, 26).dx, p(24, 26).dy)
      ..lineTo(p(31, 9).dx, p(31, 9).dy)
      ..lineTo(p(42, 39).dx, p(42, 39).dy);

    final copperPath = Path()
      ..moveTo(p(24, 26).dx, p(24, 26).dy)
      ..lineTo(p(31, 9).dx, p(31, 9).dy)
      ..lineTo(p(42, 39).dx, p(42, 39).dy);

    canvas.drawPath(bonePath, boneStyle);
    canvas.drawPath(copperPath, copperStyle);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) =>
      oldDelegate.boneColor != boneColor ||
      oldDelegate.copperColor != copperColor;
}

/// Primary lockup — mark + wordmark, as used in the nav header and footer.
class MoRmdnLockup extends StatelessWidget {
  final double markSize;
  final double fontSize;
  final Color textColor;

  const MoRmdnLockup({
    super.key,
    this.markSize = 26,
    this.fontSize = 15.5,
    this.textColor = AppColors.bone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MoRmdnMark(size: markSize),
        const SizedBox(width: 10),
        Text(
          'MoRmdn',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.45,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
