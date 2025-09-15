class AppConstants {
  // Personal Information
  static const String developerName = 'Mohamed Ramadan';
  static const String developerTitle = 'Flutter Developer';
  static const String developerSubtitle = 'Cross-Platform Mobile Expert';
  static const String developerLocation = 'Mansoura, Egypt';
  static const String developerEmail = 'mormdn@outlook.com';
  static const String developerPhone = '+201281100168';
  static const String developerLinkedIn = 'Eng. M.Ramadan';
  static const String developerGitHub = 'MoRmdn';

  // Professional Stats
  static const int yearsExperience = 4;
  static const int appsDelivered = 20;
  static const String experienceText = '4+ Years Experience';
  static const String appsText = '20+ Apps Delivered';

  // Contact Links
  static const String emailUrl = 'mailto:mormdn@outlook.com';
  static const String whatsappUrl = 'https://wa.me/+201281100168';

  // Social Links
  static const String linkedInUrl = 'https://linkedin.com/in/mormdn';
  static const String gitHubUrl = 'https://github.com/MoRmdn';
  static const String khamsatUrl = 'https://khamsat.com/user/m0rmdn';
  static const String freelancerUrl = 'https://www.freelancer.com/u/MoRmdn';
  static const String upworkUrl = 'https://www.upwork.com/freelancers/mormdn';
  static const String fiverrUrl =
      'https://www.fiverr.com/mormdn?up_rollout=true';

  // App Store Links
  static const Map<String, Map<String, String>> appStoreLinks = {
    'Arcit-AI': {
      'ios': 'https://apps.apple.com/eg/app/arcit-ai/id6503910700',
      'android':
          'https://play.google.com/store/apps/details?id=com.mormdn.arcitAI',
    },
    'Lpermis': {
      'ios': 'https://apps.apple.com/eg/app/lpermis/id1635317382',
      'android':
          'https://play.google.com/store/apps/details?id=com.demetre.code',
    },
    'Lpermis Pro': {
      'ios': 'https://apps.apple.com/eg/app/lpermis-pro/id6467557160',
      'android':
          'https://play.google.com/store/apps/details?id=com.demetre.institution',
    },
    'Mutabbib': {
      'ios':
          'https://apps.apple.com/eg/app/mutabbib-%D9%85%D8%B7%D8%A8%D8%A8/id6563148338',
      'android':
          'https://play.google.com/store/apps/details?id=com.mormdn.mutabbib',
    },
    'Saber Yamen': {
      'ios': 'https://apps.apple.com/gb/app/saber/id6467415590',
      'android':
          'https://play.google.com/store/apps/details?id=com.elevenstars.saber',
    },
  };

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Responsive Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;

  // Spacing
  static const double sectionSpacing = 80.0;
  static const double cardSpacing = 24.0;
  static const double smallSpacing = 16.0;
  static const double largeSpacing = 32.0;
}
