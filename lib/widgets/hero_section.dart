import 'dart:async' show StreamSubscription;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../services/realtime_database_service.dart';
import '../services/url_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'cursor_glow.dart';
import 'mo_rmdn_logo.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onSeeWork;

  const HeroSection({super.key, this.onSeeWork});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _totalViews = 0;
  StreamSubscription<DatabaseEvent>? _viewsSubscription;

  @override
  void initState() {
    super.initState();
    _setupViewsListener();
  }

  void _setupViewsListener() {
    _viewsSubscription = RealtimeDatabaseService.getViewsStream().listen(
      (event) {
        if (event.snapshot.exists && mounted) {
          setState(() => _totalViews = event.snapshot.value as int);
        }
      },
      onError: (_) async {
        final count = await RealtimeDatabaseService.getTotalViews();
        if (mounted) setState(() => _totalViews = count);
      },
    );
  }

  @override
  void dispose() {
    _viewsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = !isMobile && ResponsiveHelper.isTablet(context);
    final stacked = isMobile || isTablet;

    return Container(
      color: AppColors.ink900,
      child: CursorGlow(
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: 120,
              child: IgnorePointer(
                child: MoRmdnMark(
                  size: 560,
                  boneColor: AppColors.bone.withValues(alpha: 0.055),
                  copperColor: AppColors.bone.withValues(alpha: 0.055),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 20 : 32,
                isMobile ? 132 : 188,
                isMobile ? 20 : 32,
                isMobile ? 76 : 96,
              ),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppConstants.maxContentWidth,
                  ),
                  child: stacked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLeft(context, isMobile, widget.onSeeWork),
                            const SizedBox(height: 40),
                            _buildTrackRecordCard(),
                          ],
                        )
                      : IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 155,
                                child: _buildLeft(
                                  context,
                                  isMobile,
                                  widget.onSeeWork,
                                ),
                              ),
                              const SizedBox(width: 64),
                              Expanded(
                                flex: 100,
                                child: _buildTrackRecordCard(),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeft(
    BuildContext context,
    bool isMobile,
    VoidCallback? onSeeWork,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulseDot(color: AppColors.jade),
                const SizedBox(width: 7),
                Text(
                  'Open to work',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    letterSpacing: 2.2,
                    color: AppColors.jade,
                  ),
                ),
              ],
            ),
            Container(width: 26, height: 1, color: AppColors.bone18),
            Text(
              '${AppConstants.developerLocation} · UTC+3',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                letterSpacing: 2.2,
                color: AppColors.bone45,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 20 : 26),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 46 : 84,
              height: 0.92,
              fontWeight: FontWeight.w600,
              letterSpacing: -2.4,
              color: AppColors.bone,
            ),
            children: [
              const TextSpan(text: 'Flutter apps\nthat actually\n'),
              TextSpan(
                text: 'ship.',
                style: TextStyle(color: AppColors.copper),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 22 : 34),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: AppColors.bone70,
              ),
              children: [
                const TextSpan(text: "I'm "),
                TextSpan(
                  text: 'Mohamed Ramadan',
                  style: TextStyle(
                    color: AppColors.bone,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text:
                      ' — a mobile developer with four years spent building cross-platform products for teams in six countries. Bloc, GetX, Cubit, clean architecture, and a stubborn preference for 60fps.',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: isMobile ? 26 : 38),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PrimaryCta(label: 'See the work', onTap: onSeeWork ?? () {}),
            _GhostCta(
              label: AppConstants.developerEmail,
              onTap: () =>
                  UrlLauncherService.launchEmail(AppConstants.developerEmail),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackRecordCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.ink700,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Track record',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              letterSpacing: 2.2,
              color: AppColors.bone45,
            ),
          ),
          const SizedBox(height: 22),
          _Metric(
            value: AppConstants.yearsExperience,
            suffix: ' +',
            label: 'Years shipping Flutter',
            copper: true,
          ),
          Container(
            height: 1,
            color: AppColors.line,
            margin: const EdgeInsets.symmetric(vertical: 20),
          ),
          _Metric(
            value: AppConstants.appsLiveBothStores,
            label: 'Apps live on both stores',
          ),
          Container(
            height: 1,
            color: AppColors.line,
            margin: const EdgeInsets.symmetric(vertical: 20),
          ),
          _Metric(
            value: AppConstants.teamsCount,
            label: 'Teams across ${AppConstants.countriesText}',
          ),
          if (_totalViews > 0) ...[
            Container(
              height: 1,
              color: AppColors.line,
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: AppColors.bone38,
                ),
                const SizedBox(width: 8),
                Text(
                  '$_totalViews page views',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    color: AppColors.bone38,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatefulWidget {
  final int value;
  final String suffix;
  final String label;
  final bool copper;

  const _Metric({
    required this.value,
    this.suffix = '',
    required this.label,
    this.copper = false,
  });

  @override
  State<_Metric> createState() => _MetricState();
}

class _MetricState extends State<_Metric> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Text(
            '${(widget.value * _animation.value).round()}${widget.suffix}',
            style: TextStyle(
              fontSize: 44,
              height: 1,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.3,
              color: widget.copper ? AppColors.copper : AppColors.bone,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: TextStyle(fontSize: 13, color: AppColors.bone45),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.35).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

class _PrimaryCta extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryCta({required this.label, required this.onTap});

  @override
  State<_PrimaryCta> createState() => _PrimaryCtaState();
}

class _PrimaryCtaState extends State<_PrimaryCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: _hover ? AppColors.copperBright : AppColors.copper,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.ink900,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '→',
                style: TextStyle(color: AppColors.ink900, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostCta extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _GhostCta({required this.label, required this.onTap});

  @override
  State<_GhostCta> createState() => _GhostCtaState();
}

class _GhostCtaState extends State<_GhostCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: _hover ? AppColors.bone06 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hover ? AppColors.lineStrong : AppColors.line,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.bone,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
