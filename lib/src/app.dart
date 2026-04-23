import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

class PepDoseApp extends StatelessWidget {
  const PepDoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PepDose',
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildDarkTheme() {
    const bg = Color(0xFF0B0F14);
    const surface = Color(0xFF131923);
    const teal = Color(0xFF14B8A6);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: teal,
        secondary: teal,
        surface: surface,
        background: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }
}
