import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/url_launcher_service.dart';
import '../services/realtime_database_service.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _totalViews = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
    _loadViewsCount();
  }

  void _loadViewsCount() async {
    try {
      final viewsCount = await RealtimeDatabaseService.getTotalViews();
      if (mounted) {
        setState(() {
          _totalViews = viewsCount;
        });
      }
    } catch (e) {
      debugPrint('Error loading views count: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Main Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image Placeholder
                      _buildProfileImage(),

                      const SizedBox(height: 32),

                      // Name and Title
                      _buildNameAndTitle(),

                      const SizedBox(height: 24),

                      // Animated Subtitle
                      _buildAnimatedSubtitle(),

                      const SizedBox(height: 16),

                      // Location
                      _buildLocation(),

                      const SizedBox(height: 16),

                      // Views Counter
                      _buildViewsCounter(),

                      const SizedBox(height: 40),

                      // Call to Action Buttons
                      _buildCallToActionButtons(),

                      const SizedBox(height: 40),

                      // Scroll Indicator
                      _buildScrollIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: CustomPaint(painter: AnimatedBackgroundPainter()),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? 120 : 150,
      height: ResponsiveHelper.isMobile(context) ? 120 : 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(Icons.person, size: 60, color: AppColors.textPrimary),
    );
  }

  Widget _buildNameAndTitle() {
    return Column(
      children: [
        Text(
          AppConstants.developerName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 32,
              tablet: 40,
              desktop: 48,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.developerTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnimatedSubtitle() {
    return SizedBox(
      height: 60,
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            AppConstants.developerSubtitle,
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            speed: const Duration(milliseconds: 100),
          ),
          TypewriterAnimatedText(
            '${AppConstants.experienceText} | ${AppConstants.appsText}',
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.accentCyan,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            speed: const Duration(milliseconds: 100),
          ),
        ],
        repeatForever: true,
        pause: const Duration(milliseconds: 2000),
      ),
    );
  }

  Widget _buildLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: AppColors.accentGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          AppConstants.developerLocation,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildViewsCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility, color: AppColors.accentCyan, size: 16),
          const SizedBox(width: 8),
          Text(
            '${_formatViewsCount(_totalViews)} views',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewsCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildCallToActionButtons() {
    return ResponsiveHelper.isMobile(context)
        ? Column(
            children: [
              _buildPrimaryButton(),
              const SizedBox(height: 16),
              _buildSecondaryButton(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPrimaryButton(),
              const SizedBox(width: 24),
              _buildSecondaryButton(),
            ],
          );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton.icon(
      onPressed: () {
        UrlLauncherService.openUrl(AppConstants.gitHubUrl);
      },
      icon: const Icon(Icons.work_outline),
      label: const Text('View My Work'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return OutlinedButton.icon(
      onPressed: () {
        UrlLauncherService.launchEmail(AppConstants.developerEmail);
      },
      icon: const Icon(Icons.email_outlined),
      label: const Text('Contact Me'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.primaryBlue),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.textMuted,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          'Scroll to explore',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class AnimatedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw animated circles
    final center = Offset(size.width / 2, size.height / 2);

    // Large background circle
    canvas.drawCircle(
      center,
      size.width * 0.4,
      paint..color = AppColors.accentCyan.withValues(alpha: 0.05),
    );

    // Medium circles
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.15,
      paint..color = AppColors.primaryBlue.withValues(alpha: 0.08),
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      size.width * 0.12,
      paint..color = AppColors.accentPurple.withValues(alpha: 0.06),
    );

    // Small circles
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      size.width * 0.08,
      paint..color = AppColors.accentGreen.withValues(alpha: 0.1),
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.2),
      size.width * 0.06,
      paint..color = AppColors.primaryBlue.withValues(alpha: 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
