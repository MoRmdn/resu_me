import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../models/project.dart';
import '../services/url_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'eyebrow.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _countries = {
    'Arcit-AI': 'SAUDI ARABIA',
    'Lpermis': 'MOROCCO',
    'Lpermis Pro': 'MOROCCO',
    'Mutabbib': 'LIBYA',
    'Saber Yamen': 'TÜRKIYE',
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final projects = PortfolioData.projects;
    final flagship = projects.first;
    final rest = projects.skip(1).toList();

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
              const Eyebrow('03 / Projects'),
              const SizedBox(height: 18),
              Text(
                'Live on both stores.',
                style: TextStyle(
                  fontSize: isMobile ? 30 : 40,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.2,
                  color: AppColors.bone,
                ),
              ),
              const SizedBox(height: 52),
              _FlagshipCard(project: flagship, isMobile: isMobile, index: 1),
              const SizedBox(height: 20),
              _ProjectsGrid(
                projects: rest,
                isMobile: isMobile,
                countries: _countries,
                startIndex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final List<Project> projects;
  final bool isMobile;
  final Map<String, String> countries;
  final int startIndex;

  const _ProjectsGrid({
    required this.projects,
    required this.isMobile,
    required this.countries,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1040
            ? 3
            : constraints.maxWidth >= 700
            ? 2
            : 1;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (var i = 0; i < projects.length; i++)
              SizedBox(
                width: (constraints.maxWidth - (columns - 1) * 20) / columns,
                child: _ProjectCard(
                  project: projects[i],
                  index: startIndex + i,
                  country: countries[projects[i].title] ?? '',
                ),
              ),
          ],
        );
      },
    );
  }
}

String _leadTech(Project p) => p.technologies.firstWhere(
  (t) => const ['Bloc', 'Cubit', 'GetX', 'Provider', 'Riverpod'].contains(t),
  orElse: () => p.technologies.isNotEmpty ? p.technologies.first : '',
);

class _FlagshipCard extends StatefulWidget {
  final Project project;
  final bool isMobile;
  final int index;

  const _FlagshipCard({
    required this.project,
    required this.isMobile,
    required this.index,
  });

  @override
  State<_FlagshipCard> createState() => _FlagshipCardState();
}

class _FlagshipCardState extends State<_FlagshipCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(34, 34, 34, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '01',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: AppColors.copper,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Flagship · ${_leadTech(p)} · AI',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: AppColors.bone38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            p.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.9,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            p.longDescription,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.7,
              color: AppColors.bone62,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in p.tags.take(3))
                _Tag(label: t.toUpperCase(), highlight: t == _leadTech(p)),
            ],
          ),
          const SizedBox(height: 26),
          _StoreLinks(project: p),
        ],
      ),
    );

    // The media panel is deliberately a fixed height rather than stretching to
    // match the text column: IntrinsicHeight cannot measure a cover-fitted
    // image (its intrinsic height is unbounded), so a Row that stretches would
    // assert. A fixed panel also keeps a tall phone screenshot from dragging
    // the whole card out of proportion.
    final media = Container(
      height: widget.isMobile ? 320 : 420,
      decoration: BoxDecoration(
        border: widget.isMobile
            ? Border(top: BorderSide(color: AppColors.line))
            : Border(left: BorderSide(color: AppColors.line)),
        color: AppColors.ink800,
      ),
      child: ClipRect(child: _ScreenshotOrPlaceholder(assetPath: p.imageUrl)),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: AppColors.ink700,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hover
                ? AppColors.copper.withValues(alpha: 0.36)
                : AppColors.line,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 40,
                    offset: const Offset(0, 14),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: widget.isMobile
            ? Column(mainAxisSize: MainAxisSize.min, children: [content, media])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 58, child: content),
                  Expanded(flex: 42, child: media),
                ],
              ),
      ),
    );
  }
}

class _ScreenshotOrPlaceholder extends StatelessWidget {
  /// Asset path for the project's shot. Null (or a missing asset) falls back
  /// to the wireframe device placeholder from the design.
  final String? assetPath;
  const _ScreenshotOrPlaceholder({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null || path.isEmpty) return _placeholder();

    // SizedBox.expand rather than width/height: double.infinity on the Image —
    // an Image sized to infinity reports an unbounded intrinsic height, which
    // breaks any ancestor that measures intrinsics.
    return SizedBox.expand(
      child: Image.asset(
        path,
        fit: BoxFit.fitHeight,
        // Store shots lead with branding; anchor to the top so the crop keeps
        // the logo and headline rather than centring on empty chrome.
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.bone.withValues(alpha: 0.18)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'App screenshot\n1170 × 2532',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              letterSpacing: 1.6,
              height: 2,
              color: AppColors.bone28,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final String country;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.country,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.ink700,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hover
                ? AppColors.copper.withValues(alpha: 0.36)
                : AppColors.line,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 40,
                    offset: const Offset(0, 14),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      letterSpacing: 1.5,
                      color: AppColors.bone38,
                    ),
                    children: [
                      TextSpan(
                        text: '0${widget.index}',
                        style: TextStyle(color: AppColors.copper),
                      ),
                      TextSpan(text: ' · ${_leadTech(p).toUpperCase()}'),
                    ],
                  ),
                ),
                Text(
                  widget.country,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    color: AppColors.bone28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              p.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
                color: AppColors.bone,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              p.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.65,
                color: AppColors.bone62,
              ),
            ),
            Container(
              height: 1,
              color: AppColors.line,
              margin: const EdgeInsets.only(top: 22, bottom: 16),
            ),
            _StoreLinks(project: p, small: true),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool highlight;
  const _Tag({required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? AppColors.copperWash : AppColors.bone06,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 11,
          letterSpacing: 0.8,
          color: highlight ? AppColors.copper : AppColors.bone62,
        ),
      ),
    );
  }
}

class _StoreLinks extends StatelessWidget {
  final Project project;
  final bool small;
  const _StoreLinks({required this.project, this.small = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: small ? 13.5 : 14,
      fontWeight: FontWeight.w500,
      color: AppColors.bone,
    );
    return Wrap(
      spacing: 18,
      runSpacing: 8,
      children: [
        if (project.appStoreUrl != null)
          _LinkChip(
            label: 'App Store',
            style: style,
            onTap: () => UrlLauncherService.openUrl(project.appStoreUrl!),
          ),
        if (project.playStoreUrl != null)
          _LinkChip(
            label: 'Google Play',
            style: style,
            onTap: () => UrlLauncherService.openUrl(project.playStoreUrl!),
          ),
      ],
    );
  }
}

class _LinkChip extends StatefulWidget {
  final String label;
  final TextStyle style;
  final VoidCallback onTap;

  const _LinkChip({
    required this.label,
    required this.style,
    required this.onTap,
  });

  @override
  State<_LinkChip> createState() => _LinkChipState();
}

class _LinkChipState extends State<_LinkChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: widget.style.copyWith(
                color: _hover ? AppColors.copper : AppColors.bone,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '↗',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: widget.style.fontSize,
                color: _hover ? AppColors.copper : AppColors.bone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
