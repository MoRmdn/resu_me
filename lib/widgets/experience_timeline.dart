import 'package:flutter/material.dart';
import '../models/experience.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../data/portfolio_data.dart';
import 'eyebrow.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: AppColors.ink800,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile
            ? AppConstants.sectionPaddingMobile
            : AppConstants.sectionPaddingDesktop,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 16,
                runSpacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Eyebrow('02 / Experience'),
                      const SizedBox(height: 18),
                      Text(
                        'Seven teams, six countries.',
                        style: TextStyle(
                          fontSize: isMobile ? 30 : 40,
                          height: 1.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.2,
                          color: AppColors.bone,
                        ),
                      ),
                    ],
                  ),
                  if (!isMobile)
                    Text(
                      'tap a row to expand ↓',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        color: AppColors.bone38,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.line)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final e in PortfolioData.experiences)
                      _ExperienceRow(experience: e),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceRow extends StatefulWidget {
  final Experience experience;
  const _ExperienceRow({required this.experience});

  @override
  State<_ExperienceRow> createState() => _ExperienceRowState();
}

class _ExperienceRowState extends State<_ExperienceRow>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.experience;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: InkWell(
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 4,
                ),
                child: isMobile ? _mobileSummary(e) : _desktopSummary(e),
              ),
              SizeTransition(
                sizeFactor: _curve,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isMobile ? 28 : 64,
                    right: 4,
                    bottom: 30,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.75,
                            color: AppColors.bone62,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final a in e.achievements)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.copper,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    a,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: AppColors.bone62,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopSummary(Experience e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _node(),
        const SizedBox(width: 20),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: e.position,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.4,
                    color: _open ? AppColors.copper : AppColors.bone,
                  ),
                ),
                TextSpan(
                  text: ' · ${e.company}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: AppColors.bone45,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (e.isCurrent) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.jade.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'CURRENT',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    letterSpacing: 1,
                    color: AppColors.jade,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              '${e.startDate} — ${e.endDate}',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12.5,
                color: AppColors.bone45,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        _chevron(),
      ],
    );
  }

  Widget _mobileSummary(Experience e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 4), child: _node()),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.position,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _open ? AppColors.copper : AppColors.bone,
                ),
              ),
              Text(
                e.company,
                style: TextStyle(fontSize: 14, color: AppColors.bone45),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (e.isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.jade.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'CURRENT',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 10,
                          color: AppColors.jade,
                        ),
                      ),
                    ),
                  Text(
                    '${e.startDate} — ${e.endDate}',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11.5,
                      color: AppColors.bone45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _chevron(),
      ],
    );
  }

  Widget _node() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _open ? AppColors.copper : Colors.transparent,
        border: Border.all(
          color: _open
              ? AppColors.copper
              : AppColors.bone.withValues(alpha: 0.3),
        ),
      ),
      transform: Matrix4.rotationZ(0.785398),
    );
  }

  Widget _chevron() {
    return AnimatedRotation(
      duration: const Duration(milliseconds: 280),
      turns: _open ? 0.25 : 0,
      child: Icon(
        Icons.chevron_right,
        size: 20,
        color: _open ? AppColors.copper : AppColors.bone38,
      ),
    );
  }
}
