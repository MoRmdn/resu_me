import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'eyebrow.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _groups = [
    ('Languages & frameworks', 'Dart · Flutter · Python · HTML · CSS', true),
    ('State management', 'Bloc · Cubit · GetX · Provider · Riverpod', false),
    (
      'Mobile & integrations',
      'Android + iOS cross-platform · REST · GraphQL · Firebase · Google ML Kit · Google Maps · Socket.IO · Pusher',
      false,
    ),
    (
      'Payments',
      'Stripe · PayPal · Moyaser · Fawry · FlutterWave · PayU · PayStack',
      false,
    ),
    (
      'Architecture & data',
      'Clean Architecture · SOLID · OOP · Responsive design · SQLite · Hive',
      false,
    ),
    (
      'Process & testing',
      'Agile SDLC · GitFlow · GitHub · Unit testing · UI & widget testing',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final stacked = isMobile || ResponsiveHelper.isTablet(context);

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
          child: stacked
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeft(isMobile),
                    const SizedBox(height: 40),
                    _buildGrid(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildLeft(isMobile)),
                    const SizedBox(width: 64),
                    Expanded(flex: 7, child: _buildGrid()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLeft(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('04 / Skills'),
        const SizedBox(height: 18),
        Text(
          'The toolbox.',
          style: TextStyle(
            fontSize: isMobile ? 30 : 40,
            height: 1.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.2,
            color: AppColors.bone,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Text(
            'Depth where it matters — Dart, Flutter, state management and payments — and enough breadth to talk to backend, data and design without a translator.',
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: AppColors.bone62,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.line,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: [
            for (var i = 0; i < _groups.length; i++) ...[
              if (i > 0) Container(height: 1, color: AppColors.line),
              Container(
                width: double.infinity,
                color: AppColors.ink800,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _groups[i].$1.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        letterSpacing: 1.8,
                        color: _groups[i].$3
                            ? AppColors.copper
                            : AppColors.bone45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _groups[i].$2,
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.8,
                        color: AppColors.bone.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
