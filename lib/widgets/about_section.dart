import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'eyebrow.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _credentials = [
    'B.Sc. Bioinformatics — Mansoura University, 2021',
    'Google Flutter Certification — Udemy, 2022',
    'Android Basics Nanodegree — Udacity, 2020',
    'Arabic (native) · English (proficient)',
  ];

  static const _stats = [
    ('20%', 'Faster data load, Eleven Stars', true),
    ('25%', 'More bookings, Mutabbib', false),
    ('15%', 'Retention lift, Arcit-AI', false),
    ('10%', 'Smaller binary, Cyparta', false),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final stacked = isMobile || ResponsiveHelper.isTablet(context);

    return Container(
      color: AppColors.ink900,
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
                    _buildLeft(),
                    const SizedBox(height: 44),
                    _buildRight(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildLeft()),
                    const SizedBox(width: 64),
                    Expanded(flex: 7, child: _buildRight(context)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('01 / About'),
        const SizedBox(height: 18),
        Text(
          'Bioinformatics\ndegree, mobile\nobsession.',
          style: TextStyle(
            fontSize: 40,
            height: 1.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.4,
            color: AppColors.bone,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in _credentials)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    c,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12.5,
                      height: 2,
                      color: AppColors.bone45,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'I build cross-platform apps that behave like native ones — fast to open, smooth under the thumb, and honest about state.',
          style: TextStyle(
            fontSize: 19,
            height: 1.65,
            color: AppColors.bone.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 22),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 15.5,
              height: 1.7,
              color: AppColors.bone62,
            ),
            children: [
              const TextSpan(
                text:
                    "My final-year project was mobile data analysis and visualisation; that's where the habit started. Since then I've led products from an empty ",
              ),
              TextSpan(
                text: 'main.dart',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  color: AppColors.bone,
                ),
              ),
              const TextSpan(
                text:
                    ' to the App Store: a driving-school platform in Morocco, a medical social network in Libya, an AI matchmaking product in Saudi Arabia, a multi-vendor marketplace in Türkiye. Different domains, same discipline — Bloc or Cubit for anything with real business logic, clean architecture so the next developer isn\'t cursing my name, and unit and widget tests where they earn their keep.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          "I like the unglamorous wins: cutting data load times by 20%, shaving 10% off a bundle, upgrading a legacy app to null safety before it became someone's emergency.",
          style: TextStyle(
            fontSize: 15.5,
            height: 1.7,
            color: AppColors.bone62,
          ),
        ),
        const SizedBox(height: 44),
        Container(
          decoration: BoxDecoration(
            color: AppColors.line,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = (constraints.maxWidth / 150).floor().clamp(
                  2,
                  4,
                );
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1.05,
                  children: [
                    for (final s in _stats)
                      Container(
                        color: AppColors.ink900,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              s.$1,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8,
                                color: s.$3 ? AppColors.copper : AppColors.bone,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.$2,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: AppColors.bone45,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
