import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/url_launcher_service.dart';

class PortfolioNavigationBar extends StatelessWidget {
  final int currentSection;
  final Function(int) onSectionChanged;

  const PortfolioNavigationBar({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Name
          Text(
            AppConstants.developerName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),

          // Navigation Items (Desktop/Tablet)
          if (!ResponsiveHelper.isMobile(context))
            Row(
              children: [
                _buildNavItem(context, 'Home', 0),
                _buildNavItem(context, 'About', 1),
                _buildNavItem(context, 'Experience', 2),
                _buildNavItem(context, 'Projects', 3),
                _buildNavItem(context, 'Skills', 4),
                _buildNavItem(context, 'Contact', 5),
              ],
            ),

          // Social Links
          Row(
            children: [
              _buildSocialIcon(
                context,
                FontAwesomeIcons.github,
                AppConstants.gitHubUrl,
              ),
              const SizedBox(width: 12),
              _buildSocialIcon(
                context,
                FontAwesomeIcons.linkedin,
                AppConstants.linkedInUrl,
              ),
              const SizedBox(width: 12),
              _buildSocialIcon(
                context,
                FontAwesomeIcons.whatsapp,
                AppConstants.whatsappUrl,
              ),
              if (ResponsiveHelper.isMobile(context)) ...[
                const SizedBox(width: 12),
                _buildMobileMenuButton(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, int index) {
    final isActive = currentSection == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () => onSectionChanged(index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, String url) {
    return InkWell(
      onTap: () {
        UrlLauncherService.openUrl(url);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showMobileMenu(context);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.menu, color: AppColors.textSecondary),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildMobileNavItem(context, 'Home', 0),
            _buildMobileNavItem(context, 'About', 1),
            _buildMobileNavItem(context, 'Experience', 2),
            _buildMobileNavItem(context, 'Projects', 3),
            _buildMobileNavItem(context, 'Skills', 4),
            _buildMobileNavItem(context, 'Contact', 5),
            const SizedBox(height: 24),
            // Social Links in Mobile Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.github,
                  AppConstants.gitHubUrl,
                ),
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.linkedin,
                  AppConstants.linkedInUrl,
                ),
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.whatsapp,
                  AppConstants.whatsappUrl,
                ),
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.briefcase,
                  AppConstants.freelancerUrl,
                ),
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.userTie,
                  AppConstants.upworkUrl,
                ),
                _buildMobileSocialIcon(
                  context,
                  FontAwesomeIcons.handshake,
                  AppConstants.fiverrUrl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(BuildContext context, String title, int index) {
    final isActive = currentSection == index;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSectionChanged(index);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isActive ? AppColors.primaryBlue : AppColors.textPrimary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMobileSocialIcon(
    BuildContext context,
    IconData icon,
    String url,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        UrlLauncherService.openUrl(url);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}
