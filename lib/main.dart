import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';
import 'pages/home_page.dart';
import 'services/splash_screen_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  @override
  void initState() {
    super.initState();
    // Hide splash screen after Flutter is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a small delay to ensure everything is loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        SplashScreenService.hideSplashScreen();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${AppConstants.developerName} - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          secondary: AppColors.accentCyan,
          surface: AppColors.cardBackground,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2,
            ),
          ),
          labelStyle: GoogleFonts.inter(color: AppColors.textSecondary),
          hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
        ),
      ),
      home: const HomePage(),
    );
  }
}
