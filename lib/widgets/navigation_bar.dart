import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'mo_rmdn_logo.dart';

class PortfolioNavigationBar extends StatelessWidget {
  final int currentSection;
  final Function(int) onSectionChanged;

  const PortfolioNavigationBar({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  static const _links = [
    ('About', 1),
    ('Experience', 2),
    ('Projects', 3),
    ('Skills', 4),
    // ('System', 6),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile
                  ? double.infinity
                  : AppConstants.maxContentWidth,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 58,
                  padding: EdgeInsets.only(left: 20, right: isMobile ? 8 : 10),
                  decoration: BoxDecoration(
                    color: AppColors.ink700.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.line),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 50,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => onSectionChanged(0),
                        child: const MoRmdnLockup(),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 28),
                        for (final link in _links)
                          _NavLink(
                            label: link.$1,
                            active: currentSection == link.$2,
                            onTap: () => onSectionChanged(link.$2),
                          ),
                        const SizedBox(width: 8),
                      ] else
                        const SizedBox(width: 12),
                      if (isMobile)
                        IconButton(
                          onPressed: () => _showMobileMenu(context),
                          icon: Icon(
                            Icons.menu,
                            color: AppColors.bone,
                            size: 20,
                          ),
                        )
                      else
                        _HireMeButton(onTap: () => onSectionChanged(5)),
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

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.ink700,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.line),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.bone28,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ..._links.map(
                (link) => _MobileNavItem(
                  label: link.$1,
                  active: currentSection == link.$2,
                  onTap: () {
                    Navigator.pop(context);
                    onSectionChanged(link.$2);
                  },
                ),
              ),
              _MobileNavItem(
                label: 'Contact',
                active: currentSection == 5,
                onTap: () {
                  Navigator.pop(context);
                  onSectionChanged(5);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active || _hover ? AppColors.bone : AppColors.bone62;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 13.5, color: color),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.copper : AppColors.bone,
          ),
        ),
      ),
    );
  }
}

class _HireMeButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HireMeButton({required this.onTap});

  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
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
          duration: const Duration(milliseconds: 160),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: _hover ? AppColors.copperBright : AppColors.copper,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Hire me',
            style: TextStyle(
              color: AppColors.ink900,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
