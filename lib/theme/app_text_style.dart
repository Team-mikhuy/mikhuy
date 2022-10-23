import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mikhuy/theme/theme.dart';

/// Official text styles.
abstract class AppTextStyle {
  static TextStyle get headline1 {
    return _headerTextStyle.copyWith(
      fontSize: 22,
      letterSpacing: 0.07,
    );
  }

  static TextStyle get headline2 {
    return _headerTextStyle.copyWith(
      fontWeight: AppFontWeight.medium,
      letterSpacing: 0.12,
    );
  }

  static TextStyle get subtitle1 {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.medium,
      fontSize: 18,
      letterSpacing: 0.03,
    );
  }

  static TextStyle get subtitle2 {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.semibold,
      fontSize: 16,
      letterSpacing: 0.03,
    );
  }

  static TextStyle get body {
    return _bodyTextStyle.copyWith(
      letterSpacing: 0.08,
    );
  }

  static TextStyle get button {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.bold,
      fontSize: 14,
      letterSpacing: 0.32,
    );
  }

  static TextStyle get caption {
    return _bodyTextStyle.copyWith(
      fontSize: 13,
      letterSpacing: 0.05,
    );
  }

  static TextStyle get overline {
    return _bodyTextStyle.copyWith(
      fontWeight: AppFontWeight.bold,
      fontSize: 12,
      letterSpacing: 0.18,
    );
  }

  /// Base style for all body text and variants.
  static final _bodyTextStyle = GoogleFonts.urbanist(
    color: AppColors.acadia,
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
  );

  /// Base style for all heading text and variants.
  static final _headerTextStyle = GoogleFonts.rubik(
    color: AppColors.acadia,
    fontSize: 20,
    fontWeight: AppFontWeight.semibold,
  );
}

/// Weights for text styles.
abstract class AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
