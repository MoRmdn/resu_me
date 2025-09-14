import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../utils/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AutoScrollController _scrollController;
  int _currentSection = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    _scrollController.scrollToIndex(
      index,
      duration: const Duration(milliseconds: 800),
    );
    setState(() {
      _currentSection = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        children: [
          // Navigation Bar
          PortfolioNavigationBar(
            currentSection: _currentSection,
            onSectionChanged: _scrollToSection,
          ),

          // Main Content
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                // Hero Section
                AutoScrollTag(
                  key: const ValueKey(0),
                  controller: _scrollController,
                  index: 0,
                  child: const HeroSection(),
                ),

                // About Section
                AutoScrollTag(
                  key: const ValueKey(1),
                  controller: _scrollController,
                  index: 1,
                  child: const AboutSection(),
                ),

                // Experience Timeline
                AutoScrollTag(
                  key: const ValueKey(2),
                  controller: _scrollController,
                  index: 2,
                  child: const ExperienceTimeline(),
                ),

                // Projects Section
                AutoScrollTag(
                  key: const ValueKey(3),
                  controller: _scrollController,
                  index: 3,
                  child: const ProjectsSection(),
                ),

                // Skills Section
                AutoScrollTag(
                  key: const ValueKey(4),
                  controller: _scrollController,
                  index: 4,
                  child: const SkillsSection(),
                ),

                // Contact Section
                AutoScrollTag(
                  key: const ValueKey(5),
                  controller: _scrollController,
                  index: 5,
                  child: const ContactSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
