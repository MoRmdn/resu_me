import 'package:flutter/material.dart';

import '../services/realtime_database_service.dart';
import '../utils/app_colors.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/hero_section.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/projects_section.dart';
import '../widgets/site_footer.dart';
import '../widgets/skills_section.dart';
import '../widgets/tech_marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  int _currentSection = 0;
  double _scrollProgress = 0;
  int _totalViews = 0;

  static const _techItems = [
    'Dart',
    'Flutter',
    'Bloc',
    'GetX',
    'Riverpod',
    'Firebase',
    'GraphQL',
    'ML Kit',
    'Clean Architecture',
    'Stripe',
    'Socket.IO',
    'Hive',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _trackPageView();
    RealtimeDatabaseService.getViewsStream().listen((event) {
      if (event.snapshot.exists && mounted) {
        setState(() => _totalViews = event.snapshot.value as int);
      }
    });
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    setState(() {
      _scrollProgress = max > 0
          ? (_scrollController.offset / max).clamp(0, 1)
          : 0;
    });
  }

  void _trackPageView() async {
    try {
      await RealtimeDatabaseService.incrementViews();
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    setState(() => _currentSection = index);
    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink900,
      body: Stack(
        children: [
          // SingleChildScrollView (not ListView): every section must be built
          // and laid out so the nav's GlobalKeys always resolve, and so a
          // section that resizes (the experience accordion) never fights the
          // lazy sliver's child-geometry bookkeeping.
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  key: _sectionKeys[0],
                  onSeeWork: () => _scrollToSection(3),
                ),
                TechMarquee(items: _techItems),
                AboutSection(key: _sectionKeys[1]),
                ExperienceTimeline(key: _sectionKeys[2]),
                ProjectsSection(key: _sectionKeys[3]),
                SkillsSection(key: _sectionKeys[4]),
                ContactSection(key: _sectionKeys[5]),
                // SystemSection(key: _sectionKeys[6]),
                SiteFooter(
                  views: _totalViews,
                  onBackToTop: () => _scrollToSection(0),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: AppColors.bone.withValues(alpha: 0.06),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _scrollProgress.toDouble(),
                  child: Container(color: AppColors.copper),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavigationBar(
              currentSection: _currentSection,
              onSectionChanged: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}
