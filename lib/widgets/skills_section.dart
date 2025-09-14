import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../data/portfolio_data.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // Skills Categories
          _buildSkillsCategories(context),
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
                'Technical Skills',
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
                'Proficiency levels across different technologies and frameworks',
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

  Widget _buildSkillsCategories(BuildContext context) {
    final categories = ['Primary', 'Secondary', 'Tools'];

    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: categories.map<Widget>((category) {
          final categorySkills = PortfolioData.skills
              .where((skill) => skill.category == category)
              .toList();

          return SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: _buildSkillCategory(context, category, categorySkills),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillCategory(
    BuildContext context,
    String category,
    List skills,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        _buildCategoryHeader(context, category),

        const SizedBox(height: 24),

        // Skills Grid
        _buildSkillsGrid(context, skills),
      ],
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String category) {
    Color categoryColor;
    IconData categoryIcon;

    switch (category) {
      case 'Primary':
        categoryColor = AppColors.primaryBlue;
        categoryIcon = Icons.star;
        break;
      case 'Secondary':
        categoryColor = AppColors.accentCyan;
        categoryIcon = Icons.extension;
        break;
      case 'Tools':
        categoryColor = AppColors.accentPurple;
        categoryIcon = Icons.build;
        break;
      default:
        categoryColor = AppColors.textMuted;
        categoryIcon = Icons.code;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(categoryIcon, color: categoryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          '$category Skills',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(BuildContext context, List skills) {
    final columns = ResponsiveHelper.isMobile(context) ? 1 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 3 : 2.5,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) => _buildSkillCard(context, skills[index]),
    );
  }

  Widget _buildSkillCard(BuildContext context, skill) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill Name and Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${skill.percentage.toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          _buildProgressBar(skill.percentage),

          const SizedBox(height: 8),

          // Description
          Text(
            skill.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage / 100,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
