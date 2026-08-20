import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/url_launcher_service.dart';
import '../services/realtime_database_service.dart';
import 'eyebrow.dart';

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeft(isMobile),
                        const SizedBox(height: 44),
                        _buildLinksPanel(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 100, child: _buildLeft(isMobile)),
                        const SizedBox(width: 64),
                        Expanded(flex: 85, child: _buildLinksPanel()),
                      ],
                    ),
              const SizedBox(height: 64),
              _buildMessageForm(isMobile),
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
        const Eyebrow('05 / Contact'),
        const SizedBox(height: 18),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 38 : 60,
              height: 0.98,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.8,
              color: AppColors.bone,
            ),
            children: [
              const TextSpan(text: 'Got an app\nto '),
              TextSpan(
                text: 'build?',
                style: TextStyle(color: AppColors.copper),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            "Full-time, contract or a second pair of hands on a release that's slipping — send the details and I'll reply within a day.",
            style: TextStyle(
              fontSize: 16.5,
              height: 1.65,
              color: AppColors.bone70,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PrimaryPill(
              label: AppConstants.developerEmail,
              onTap: () => UrlLauncherService.openUrl(AppConstants.emailUrl),
            ),
            _GhostPill(
              label: '+20 128 110 0168',
              onTap: () =>
                  UrlLauncherService.launchPhone(AppConstants.developerPhone),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinksPanel() {
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
            _LinkRow(
              label: 'LinkedIn',
              value: '${AppConstants.developerLinkedIn} ↗',
              onTap: () => UrlLauncherService.openUrl(AppConstants.linkedInUrl),
            ),
            Container(height: 1, color: AppColors.line),
            _LinkRow(
              label: 'GitHub',
              value: '${AppConstants.developerGitHub} ↗',
              onTap: () => UrlLauncherService.openUrl(AppConstants.gitHubUrl),
            ),
            Container(height: 1, color: AppColors.line),
            _LinkRow(
              label: 'Khamsat',
              value: 'M0Rmdn ↗',
              onTap: () => UrlLauncherService.openUrl(AppConstants.khamsatUrl),
            ),
            Container(height: 1, color: AppColors.line),
            Container(
              width: double.infinity,
              color: AppColors.ink900,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AVAILABILITY',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      letterSpacing: 1.8,
                      color: AppColors.bone38,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.jade,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'Taking new work · ${AppConstants.developerLocation.split(',').first} / remote',
                        style: TextStyle(fontSize: 14.5, color: AppColors.jade),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: AppColors.ink700,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Or send a message directly'),
            const SizedBox(height: 20),
            _field(
              _nameController,
              'Full Name',
              'Enter your full name',
              (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            _field(
              _emailController,
              'Email Address',
              'Enter your email address',
              (v) {
                if (v == null || v.isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
                    children: [
                      _field(
                        _projectTypeController,
                        'Project Type',
                        'e.g., Mobile App',
                        null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        _budgetController,
                        'Budget Range',
                        'e.g., \$5,000 - \$10,000',
                        null,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _field(
                          _projectTypeController,
                          'Project Type',
                          'e.g., Mobile App',
                          null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _field(
                          _budgetController,
                          'Budget Range',
                          'e.g., \$5,000 - \$10,000',
                          null,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            _field(
              _messageController,
              'Project Description',
              'Tell me about your project...',
              (v) => v == null || v.isEmpty
                  ? 'Please describe your project'
                  : null,
              maxLines: 4,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.ink900,
                          ),
                        ),
                      )
                    : const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint,
    String? Function(String?)? validator, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.bone, fontSize: 15),
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: validator,
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final success = await RealtimeDatabaseService.submitContactForm(
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

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Message sent successfully! I'll get back to you soon.",
            ),
            backgroundColor: AppColors.jade,
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _projectTypeController.clear();
        _budgetController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to send message. Please try again.'),
            backgroundColor: AppColors.rose,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.rose),
      );
    }
  }
}

class _LinkRow extends StatefulWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _LinkRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_LinkRow> createState() => _LinkRowState();
}

class _LinkRowState extends State<_LinkRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          color: _hover ? AppColors.ink700 : AppColors.ink900,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bone,
                ),
              ),
              Text(
                widget.value,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 13,
                  color: AppColors.bone45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryPill extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryPill({required this.label, required this.onTap});

  @override
  State<_PrimaryPill> createState() => _PrimaryPillState();
}

class _PrimaryPillState extends State<_PrimaryPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
            color: _hover ? AppColors.copperBright : AppColors.copper,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.ink900,
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostPill extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostPill({required this.label, required this.onTap});

  @override
  State<_GhostPill> createState() => _GhostPillState();
}

class _GhostPillState extends State<_GhostPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: _hover ? AppColors.bone06 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hover ? AppColors.lineStrong : AppColors.line,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              color: AppColors.bone,
              fontSize: 14.5,
            ),
          ),
        ),
      ),
    );
  }
}
