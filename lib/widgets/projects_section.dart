import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../data/portfolio_data.dart';
import '../services/url_launcher_service.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // Projects Grid
          _buildProjectsGrid(context),
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
                'Featured Projects',
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
              const SizedBox(height: 16),
              Text(
                'A showcase of my most impactful mobile applications',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(BuildContext context) {
    final columns = ResponsiveHelper.getResponsiveColumns(context);

    return AnimationConfiguration.staggeredGrid(
      position: 1,
      duration: const Duration(milliseconds: 600),
      columnCount: columns,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.9,
        ),
        itemCount: PortfolioData.projects.length,
        itemBuilder: (context, index) => SlideAnimation(
          horizontalOffset: 50.0,
          child: FadeInAnimation(
            child: _buildProjectCard(context, PortfolioData.projects[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, project) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image/Icon
          _buildProjectImage(),

          // Project Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  _buildProjectHeader(context, project),

                  const SizedBox(height: 12),

                  // Description
                  _buildProjectDescription(context, project),

                  const SizedBox(height: 16),

                  // Technologies
                  _buildProjectTechnologies(context, project),

                  const Spacer(),

                  // Achievement
                  _buildProjectAchievement(context, project),

                  const SizedBox(height: 16),

                  // Action Buttons
                  _buildProjectActions(context, project),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectImage() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Center(
        child: Icon(
          Icons.phone_android,
          size: 48,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildProjectHeader(BuildContext context, project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            project.category,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDescription(BuildContext context, project) {
    return Text(
      project.description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProjectTechnologies(BuildContext context, project) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: project.technologies
          .take(3)
          .map<Widget>(
            (tech) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tech,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildProjectAchievement(BuildContext context, project) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: AppColors.accentGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              project.achievement,
              style: const TextStyle(
                color: AppColors.accentGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectActions(BuildContext context, project) {
    return Row(
      children: [
        if (project.appStoreUrl != null)
          Expanded(
            child: _buildActionButton(
              context,
              'App Store',
              FontAwesomeIcons.apple,
              () {
                UrlLauncherService.openUrl(project.appStoreUrl!);
              },
            ),
          ),
        if (project.appStoreUrl != null && project.playStoreUrl != null)
          const SizedBox(width: 8),
        if (project.playStoreUrl != null)
          Expanded(
            child: _buildActionButton(
              context,
              'Play Store',
              FontAwesomeIcons.googlePlay,
              () {
                UrlLauncherService.openUrl(project.playStoreUrl!);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: AppColors.primaryBlue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
