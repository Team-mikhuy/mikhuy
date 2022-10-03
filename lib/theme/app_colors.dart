import 'package:flutter/material.dart';

/// Official color palette.
abstract class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const acadia = Color(0xFF1B1004);

  static const danger = Color(0xFFF90000);
  static const success = Color(0xFF53A700);

  static const int _flushOrangeBase = 0xFFF97D00;
  static const int _blueMalibuBase = 0xFF88ACFF;
  static const int _greyBase = 0xFFD0D0D0;

  /// Primary color swatch.
  static const flushOrange = MaterialColor(
    _flushOrangeBase,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCD80),
      300: Color(0xFFFFB84D),
      400: Color(0xFFFFB84D),
      500: Color(0xFFFF9900),
      600: Color(0xFFFF9900),
      700: Color(_flushOrangeBase),
      800: Color(0xFFDA6D00),
      900: Color(0xFFBB5E00),
    },
  );

  /// Secondary color swatch.
  static const blueMalibu = MaterialColor(
    _blueMalibuBase,
    <int, Color>{
      50: Color(0xFFE3F4FF),
      100: Color(0xFFCBEBFF),
      200: Color(0xFFB3E1FF),
      300: Color(0xFFA9D4FF),
      400: Color(0xFF9EC6FF),
      500: Color(_blueMalibuBase),
      600: Color(0xFF7391FF),
      700: Color(0xFF5D76FF),
      800: Color(0xFF485CFF),
      900: Color(0xFF3241FF),
    },
  );

  /// Neutral color swatch.
  static const grey = MaterialColor(
    _blueMalibuBase,
    <int, Color>{
      50: Color(0xFFF7F7F7),
      100: Color(0xFFEFEFEF),
      200: Color(0xFFE7E7E7),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFD8D8D8),
      500: Color(_greyBase),
      600: Color(0xFFC8C8C8),
      700: Color(0xFFAFAFAF),
      800: Color(0xFF969696),
      900: Color(0xFF7D7D7D),
    },
  );
}
