import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'services/splash_screen_service.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';

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
        scaffoldBackgroundColor: AppColors.ink900,
        // Archivo & JetBrains Mono are loaded via a <link> in web/index.html
        // (the google_fonts package doesn't compile on this Flutter SDK).
        fontFamily: 'Archivo',
        colorScheme: ColorScheme.dark(
          primary: AppColors.copper,
          secondary: AppColors.jade,
          surface: AppColors.ink700,
          onPrimary: AppColors.ink900,
          onSecondary: AppColors.ink900,
          onSurface: AppColors.bone,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 96,
            height: 0.9,
            fontWeight: FontWeight.w600,
            letterSpacing: -3.8,
            color: AppColors.bone,
          ),
          headlineLarge: TextStyle(
            fontSize: 54,
            height: 1.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.9,
            color: AppColors.bone,
          ),
          headlineMedium: TextStyle(
            fontSize: 34,
            height: 1.05,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.0,
            color: AppColors.bone,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: AppColors.bone,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppColors.bone70,
          ),
          bodyMedium: TextStyle(
            fontSize: 15.5,
            height: 1.65,
            color: AppColors.bone70,
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.bone45,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.bone,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.copper,
            foregroundColor: AppColors.ink900,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.ink700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.line),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.ink600,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.copper, width: 1.5),
          ),
          labelStyle: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 11,
            letterSpacing: 1.6,
            color: AppColors.bone45,
          ),
          hintStyle: TextStyle(color: AppColors.bone38),
        ),
      ),
      home: const HomePage(),
    );
  }
}
