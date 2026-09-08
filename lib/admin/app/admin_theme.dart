import 'package:flutter/material.dart';

class AdminTheme {
  static const Color purple = Color(0xFF7048B6);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFFF8FF),
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
    );
  }
}