import 'package:flutter/material.dart';

abstract final class PenninoColors {
  static const base = Color(0xff0b0c0e);
  static const raised = Color(0xff16181c);
  static const inset = Color(0xff060708);
  static const accent = Color(0xff4d8dff);
  static const accentSoft = Color(0xffa8c8ff);
  static const accentContainer = Color(0xff16336b);
  static const steel = Color(0xffb4bbc6);
  static const ink = Color(0xfff5f7fa);
  static const hairline = Color(0xff2f343b);
}

ThemeData buildPenninoTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: PenninoColors.accent,
        onPrimary: PenninoColors.inset,
        primaryContainer: PenninoColors.accentContainer,
        onPrimaryContainer: PenninoColors.accentSoft,
        secondary: PenninoColors.steel,
        onSecondary: PenninoColors.inset,
        // A container role the scheme leaves out comes back as the base
        // colour beside it, so the update row - which asks for
        // `secondaryContainer` - was painting in the light steel of
        // `secondary`. This is the same dark tone the surfaces use,
        // tinted the way `secondary` is.
        secondaryContainer: Color(0xff2b3038),
        onSecondaryContainer: PenninoColors.ink,
        surface: PenninoColors.base,
        onSurface: PenninoColors.ink,
        surfaceContainerLowest: PenninoColors.inset,
        surfaceContainerLow: Color(0xff111317),
        surfaceContainer: PenninoColors.raised,
        surfaceContainerHigh: Color(0xff22262c),
        outline: Color(0xff8b93a1),
        outlineVariant: Color(0xff2f343b),
      ),
      scaffoldBackgroundColor: PenninoColors.base,
      dividerColor: PenninoColors.hairline,
      dividerTheme: const DividerThemeData(
        color: PenninoColors.hairline,
        thickness: 1,
        space: 1,
      ),
      splashFactory: InkSparkle.splashFactory,
      textTheme: _textTheme,
      // Flat, tonal surfaces: depth comes from the step between two
      // neighbouring surface tones and a hairline, not from drop shadows.
      appBarTheme: const AppBarTheme(
        backgroundColor: PenninoColors.base,
        foregroundColor: PenninoColors.accentSoft,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: PenninoColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: PenninoColors.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PenninoColors.hairline),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: PenninoColors.steel,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PenninoColors.raised,
        selectedColor: PenninoColors.accentContainer,
        checkmarkColor: PenninoColors.accentSoft,
        side: const BorderSide(color: PenninoColors.hairline),
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(color: PenninoColors.ink),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PenninoColors.accent,
        foregroundColor: PenninoColors.inset,
        elevation: 2,
        highlightElevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: PenninoColors.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: PenninoColors.hairline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PenninoColors.raised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: PenninoColors.hairline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff22262c),
        contentTextStyle: const TextStyle(color: PenninoColors.ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PenninoColors.inset,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PenninoColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PenninoColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PenninoColors.accent,
            width: 1.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: PenninoColors.accentSoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

/// Tighter headings and a slightly roomier body than the Material defaults,
/// on the platform's own font so nothing has to be bundled.
const _textTheme = TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -.2),
  titleMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
  bodyMedium: TextStyle(height: 1.35),
  bodySmall: TextStyle(height: 1.3, color: PenninoColors.steel),
  labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: .1),
);
