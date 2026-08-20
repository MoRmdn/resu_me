import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'mo_rmdn_logo.dart';

class SiteFooter extends StatelessWidget {
  final VoidCallback onBackToTop;
  final int views;

  const SiteFooter({super.key, required this.onBackToTop, this.views = 0});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final year = DateTime.now().year;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.ink900,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: 38,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 18,
              runSpacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MoRmdnMark(size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'MoRmdn © $year · Built with Flutter Web',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11.5,
                        letterSpacing: 1.4,
                        color: AppColors.bone38,
                      ),
                    ),
                  ],
                ),
                Text(
                  views > 0
                      ? 'Obsidian & Copper v1.0 · $views views'
                      : 'Obsidian & Copper v1.0',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11.5,
                    letterSpacing: 1.4,
                    color: AppColors.bone38,
                  ),
                ),
                GestureDetector(
                  onTap: onBackToTop,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'Back to top ↑',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11.5,
                        letterSpacing: 1.4,
                        color: AppColors.bone38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
