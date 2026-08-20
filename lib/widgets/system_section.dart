import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'eyebrow.dart';
import 'mo_rmdn_logo.dart';

/// Appendix — the design system behind this page, for anyone curious
/// about the tokens. See DESIGN-SYSTEM.md / LOGO.md for the full spec.
class SystemSection extends StatelessWidget {
  const SystemSection({super.key});

  static const _swatches = [
    ('0A0A0C', AppColors.ink900, false),
    ('16161B', AppColors.ink700, false),
    ('F2EEE7', AppColors.bone, true),
    ('F2762E', AppColors.copper, false),
  ];

  static const _motion = [
    ('320ms', 'Reveal-up, 60ms stagger', 'fadeIn + slideY'),
    (
      '280ms',
      'Accordion height + node fill',
      'AnimatedSize + AnimatedRotation',
    ),
    ('~26s', 'Tech marquee, pause on hover', 'Ticker-driven ListView offset'),
    (
      '900ms',
      'Metric count-up, tabular figures',
      'AnimationController + tween',
    ),
    ('180ms', 'Card lift + border warm on hover', 'AnimatedContainer'),
    ('≤120ms', 'Reduced-motion fallback: opacity only', '—'),
  ];

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
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('Appendix / Design system'),
                    const SizedBox(height: 18),
                    Text(
                      'Obsidian & Copper',
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.2,
                        color: AppColors.bone,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The system behind this page — layers, hairlines and one accent, never blur.',
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.7,
                        color: AppColors.bone62,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _card(300, _paletteCard()),
                  _card(300, _typeCard()),
                  _card(300, _logoCard()),
                  _card(300, _motionCard()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(double minWidth, Widget child) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: 380),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppColors.ink900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: child,
      ),
    );
  }

  Widget _cardLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        letterSpacing: 1.8,
        color: AppColors.bone45,
      ),
    ),
  );

  Widget _paletteCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _cardLabel('Palette'),
        Row(
          children: [
            for (final s in _swatches)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: s.$2,
                          borderRadius: BorderRadius.circular(8),
                          border: s.$3
                              ? null
                              : Border.all(
                                  color: AppColors.bone.withValues(alpha: 0.14),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.$1,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 10,
                          color: s.$1 == 'F2762E'
                              ? AppColors.copper
                              : AppColors.bone45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _typeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _cardLabel('Type'),
        Text(
          'Archivo',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.4,
            color: AppColors.bone,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'display · 84/40/24 · 600 · −0.04em',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            color: AppColors.bone45,
          ),
        ),
        Container(
          height: 1,
          color: AppColors.line,
          margin: const EdgeInsets.symmetric(vertical: 18),
        ),
        Text(
          'JetBrains Mono',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 19,
            color: AppColors.bone,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'eyebrow · 11px · 0.18em · UPPER',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            color: AppColors.bone45,
          ),
        ),
      ],
    );
  }

  Widget _logoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _cardLabel('Logo — the composed M'),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.ink900,
                  border: Border.all(
                    color: AppColors.bone.withValues(alpha: 0.14),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: MoRmdnMark(size: 40)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.bone,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: MoRmdnMark(
                    size: 40,
                    boneColor: Color(0xFF131316),
                    copperColor: Color(0xFFD95A15),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.ink700,
            border: Border.all(color: AppColors.bone.withValues(alpha: 0.14)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [MoRmdnLockup()],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'One folded stroke, four folds. Clear space = stroke × 2. Minimum 16px.',
          style: TextStyle(
            fontSize: 12.5,
            height: 1.6,
            color: AppColors.bone45,
          ),
        ),
      ],
    );
  }

  Widget _motionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _cardLabel('Motion → Flutter'),
        for (final m in _motion)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 54,
                  child: Text(
                    m.$1,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: AppColors.copper,
                    ),
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: AppColors.bone70,
                      ),
                      children: [
                        TextSpan(text: '${m.$2} — '),
                        TextSpan(
                          text: m.$3,
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11.5,
                            color: AppColors.bone45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
