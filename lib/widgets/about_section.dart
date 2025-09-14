import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // About Content
          _buildAboutContent(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // Skills Badges
          _buildSkillsBadges(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // Statistics
          _buildStatistics(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            children: [
              Text(
                'About Me',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Row(
            children: [
              // Profile Image
              if (!ResponsiveHelper.isMobile(context)) ...[
                Expanded(flex: 2, child: _buildProfileImage()),
                const SizedBox(width: 48),
              ],

              // About Text
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Summary',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A highly skilled Mobile Developer with over ${AppConstants.yearsExperience} years of experience specializing in cross-platform mobile development with Flutter. Proven expertise in building high-performance, scalable applications for Android and iOS, using state-of-the-art architectures like Bloc, GetX, and Cubit.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Strong knowledge in API integrations, state management, and clean code practices. Passionate about continuous learning and delivering top-quality software solutions that drive business growth and user satisfaction.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSpecializations(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.cardGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.person, size: 80, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSpecializations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Specializations:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSpecializationChip('Flutter Development'),
            _buildSpecializationChip('State Management'),
            _buildSpecializationChip('API Integration'),
            _buildSpecializationChip('Clean Architecture'),
            _buildSpecializationChip('Performance Optimization'),
            _buildSpecializationChip('Cross-platform Apps'),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecializationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSkillsBadges(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            children: [
              Text(
                'Core Technologies',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildTechBadge('Dart', AppColors.primaryBlue),
                  _buildTechBadge('Flutter', AppColors.accentCyan),
                  _buildTechBadge('Bloc', AppColors.accentPurple),
                  _buildTechBadge('GetX', AppColors.accentGreen),
                  _buildTechBadge('Cubit', AppColors.warning),
                  _buildTechBadge('Firebase', AppColors.error),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechBadge(String tech, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            tech,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ResponsiveHelper.isMobile(context)
                ? Column(
                    children: [
                      _buildStatItem(
                        '${AppConstants.yearsExperience}+',
                        'Years Experience',
                      ),
                      const SizedBox(height: 24),
                      _buildStatItem(
                        '${AppConstants.appsDelivered}+',
                        'Apps Delivered',
                      ),
                      const SizedBox(height: 24),
                      _buildStatItem('100%', 'Client Satisfaction'),
                      const SizedBox(height: 24),
                      _buildStatItem('2', 'Platforms Supported'),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        '${AppConstants.yearsExperience}+',
                        'Years Experience',
                      ),
                      _buildStatItem(
                        '${AppConstants.appsDelivered}+',
                        'Apps Delivered',
                      ),
                      _buildStatItem('100%', 'Client Satisfaction'),
                      _buildStatItem('2', 'Platforms Supported'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
