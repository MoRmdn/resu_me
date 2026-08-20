import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;

import '../utils/app_colors.dart';

/// Infinite horizontal tech strip. Pauses on hover (desktop).
class TechMarquee extends StatefulWidget {
  final List<String> items;
  final double pixelsPerSecond;

  const TechMarquee({
    super.key,
    required this.items,
    this.pixelsPerSecond = 34,
  });

  @override
  State<TechMarquee> createState() => _TechMarqueeState();
}

class _TechMarqueeState extends State<TechMarquee>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final ScrollController _scrollController = ScrollController();
  Duration _lastElapsed = Duration.zero;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!_scrollController.hasClients) return;
    // hasClients alone isn't enough: on the first frames the position exists
    // but hasn't been laid out, and reading maxScrollExtent then throws.
    final position = _scrollController.position;
    if (!position.hasContentDimensions || !position.hasPixels) return;

    final delta = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (_paused) return;

    final max = position.maxScrollExtent;
    if (max <= 0) return;
    final next = position.pixels + widget.pixelsPerSecond * delta;
    _scrollController.jumpTo(next >= max ? next - max : next);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Repeat the sequence enough times to always overflow the viewport.
    final loops = List.generate(
      6,
      (_) => widget.items,
    ).expand((e) => e).toList();

    return MouseRegion(
      onEnter: (_) => setState(() => _paused = true),
      onExit: (_) => setState(() => _paused = false),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.ink800,
          border: Border(
            top: BorderSide(color: AppColors.line),
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loops.length,
          itemBuilder: (context, index) => _buildItem(loops[index]),
        ),
      ),
    );
  }

  Widget _buildItem(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12.5,
                letterSpacing: 2.2,
                color: AppColors.bone45,
              ),
            ),
            const SizedBox(width: 20),
            Text('◆', style: TextStyle(fontSize: 12, color: AppColors.copper)),
          ],
        ),
      ),
    );
  }
}
