import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/url_launcher_service.dart';
import '../services/firestore_service.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _projectTypeController.dispose();
    _budgetController.dispose();
    _messageController.dispose();
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

          // Contact Content
          _buildContactContent(context),

          const SizedBox(height: AppConstants.sectionSpacing),

          // Footer
          _buildFooter(context),
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
                'Get In Touch',
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
                'Ready to bring your mobile app idea to life? Let\'s discuss your project.',
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

  Widget _buildContactContent(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ResponsiveHelper.isMobile(context)
              ? Column(
                  children: [
                    _buildContactInfo(context),
                    const SizedBox(height: 32),
                    _buildContactForm(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildContactInfo(context)),
                    const SizedBox(width: 48),
                    Expanded(flex: 1, child: _buildContactForm(context)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        _buildContactItem(
          context,
          Icons.email,
          'Email',
          AppConstants.developerEmail,
          () {
            UrlLauncherService.launchEmail(AppConstants.developerEmail);
          },
        ),

        _buildContactItem(
          context,
          Icons.phone,
          'Phone',
          AppConstants.developerPhone,
          () {
            UrlLauncherService.launchPhone(AppConstants.developerPhone);
          },
        ),

        _buildContactItem(
          context,
          Icons.location_on,
          'Location',
          AppConstants.developerLocation,
          null,
        ),

        const SizedBox(height: 32),

        Text(
          'Social Links',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            _buildSocialButton(
              context,
              FontAwesomeIcons.github,
              'GitHub',
              AppColors.textPrimary,
              () {
                UrlLauncherService.openUrl(AppConstants.gitHubUrl);
              },
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              context,
              FontAwesomeIcons.linkedin,
              'LinkedIn',
              AppColors.primaryBlue,
              () {
                UrlLauncherService.openUrl(AppConstants.linkedInUrl);
              },
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              context,
              FontAwesomeIcons.globe,
              'Khamsat',
              AppColors.accentGreen,
              () {
                UrlLauncherService.openUrl(AppConstants.khamsatUrl);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Project Type Field
            TextFormField(
              controller: _projectTypeController,
              decoration: const InputDecoration(
                labelText: 'Project Type',
                hintText: 'e.g., Mobile App, Web App, etc.',
              ),
            ),
            const SizedBox(height: 16),

            // Budget Field
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Budget Range',
                hintText: 'e.g., \$5,000 - \$10,000',
              ),
            ),
            const SizedBox(height: 16),

            // Message Field
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Project Description',
                hintText: 'Tell me about your project...',
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe your project';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textPrimary,
                          ),
                        ),
                      )
                    : const Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Submit form to Firestore
        bool success = await FirestoreService.submitContactForm(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          projectType: _projectTypeController.text.trim().isEmpty
              ? null
              : _projectTypeController.text.trim(),
          budget: _budgetController.text.trim().isEmpty
              ? null
              : _budgetController.text.trim(),
          message: _messageController.text.trim(),
        );

        setState(() {
          _isSubmitting = false;
        });

        if (success) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Message sent successfully! I\'ll get back to you soon.',
                ),
                backgroundColor: AppColors.accentGreen,
                duration: const Duration(seconds: 4),
              ),
            );
          }

          // Clear form
          _nameController.clear();
          _emailController.clear();
          _projectTypeController.clear();
          _budgetController.clear();
          _messageController.clear();
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Failed to send message. Please try again.',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Widget _buildFooter(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '© 2025 ${AppConstants.developerName}. All rights reserved.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  'Built with Flutter • Designed with ❤️',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
