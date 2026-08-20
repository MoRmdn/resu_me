import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../utils/app_colors.dart';
import '../utils/responsive_helper.dart';

/// A copper radial glow that trails the pointer with eased (lerped) follow.
/// Desktop only — on touch there is no cursor to follow.
///
/// Deliberately rebuild-free: the pointer position lives in a [ValueNotifier]
/// that is handed to the painter as its `repaint` [Listenable], so movement
/// repaints one [RepaintBoundary] and never calls `setState`. Driving this
/// from `setState` in `MouseRegion.onHover` corrupts Flutter web's mouse
/// tracker and freezes pointer input for the whole page — see CLAUDE.md.
class CursorGlow extends StatefulWidget {
  /// Painted behind this child.
  final Widget child;

  /// Radius of the glow in logical pixels.
  final double radius;

  /// Peak opacity at the centre of the glow.
  final double opacity;

  /// Per-frame lerp factor — lower trails further behind the pointer.
  final double easing;

  const CursorGlow({
    super.key,
    required this.child,
    this.radius = 320,
    this.opacity = 0.16,
    this.easing = 0.075,
  });

  @override
  State<CursorGlow> createState() => _CursorGlowState();
}

class _CursorGlowState extends State<CursorGlow>
    with SingleTickerProviderStateMixin {
  /// Where the glow is actually drawn. Drives the painter's repaint.
  final ValueNotifier<Offset?> _painted = ValueNotifier(null);

  /// Where the pointer is. The painted position eases toward this.
  Offset? _target;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration _) {
    final target = _target;
    final current = _painted.value;
    if (target == null || current == null) {
      _ticker.stop();
      return;
    }
    // Close enough — settle exactly and idle the ticker until the next move.
    if ((target - current).distanceSquared < 0.25) {
      _painted.value = target;
      _ticker.stop();
      return;
    }
    _painted.value = Offset.lerp(current, target, widget.easing)!;
  }

  void _moveTo(Offset position) {
    _target = position;
    // First sighting of the pointer: appear where it is rather than sliding
    // in from a stale corner.
    _painted.value ??= position;
    if (!_ticker.isActive) _ticker.start();
  }

  void _clear() {
    _target = null;
    _ticker.stop();
    _painted.value = null;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _painted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No cursor to follow on touch layouts, and the extra layer isn't worth
    // the paint cost there.
    if (ResponsiveHelper.isMobile(context)) return widget.child;

    return MouseRegion(
      // Position tracking only — this must not absorb taps.
      opaque: false,
      hitTestBehavior: HitTestBehavior.translucent,
      onHover: (event) => _moveTo(event.localPosition),
      onExit: (_) => _clear(),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _GlowPainter(
                    position: _painted,
                    radius: widget.radius,
                    opacity: widget.opacity,
                  ),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final ValueListenable<Offset?> position;
  final double radius;
  final double opacity;

  _GlowPainter({
    required this.position,
    required this.radius,
    required this.opacity,
  }) : super(repaint: position);

  @override
  void paint(Canvas canvas, Size size) {
    final centre = position.value;
    if (centre == null) return;

    final rect = Rect.fromCircle(center: centre, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.copper.withValues(alpha: opacity),
          AppColors.copper.withValues(alpha: 0),
        ],
        // Matches the design's copper → transparent falloff at 62%.
        stops: const [0.0, 0.62],
      ).createShader(rect);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.radius != radius ||
      oldDelegate.opacity != opacity;
}
