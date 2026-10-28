import 'package:flutter/material.dart';

const saffron = Color(0xFFEB7A1D);
const maroon = Color(0xFF6E1E1E);
const cream = Color(0xFFFDF6EC);
const deepMaroon = Color(0xFF531414);

// A soft, warm shadow for cards — the single biggest "premium feel" lever
// after fonts. Apply with `boxShadow: cardShadow` on a Container decoration.
final List<BoxShadow> cardShadow = [
  BoxShadow(color: maroon.withValues(alpha: 0.07), blurRadius: 18, offset: const Offset(0, 6)),
];

ThemeData buildDiyaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: saffron,
    primary: saffron,
    brightness: Brightness.light,
  ).copyWith(surface: cream);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: cream,
    // Poppins for Latin UI; Devanagari falls back to the Tiro Sanskrit face.
    fontFamily: 'Poppins',
    fontFamilyFallback: const ['TiroDevanagari'],
    appBarTheme: const AppBarTheme(
      backgroundColor: maroon,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: saffron.withValues(alpha: 0.16),
      elevation: 3,
      height: 66,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: maroon),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? saffron : Colors.black45),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      side: BorderSide(color: saffron.withValues(alpha: 0.4)),
      labelStyle: const TextStyle(color: maroon, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: maroon,
        side: BorderSide(color: saffron.withValues(alpha: 0.5)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    listTileTheme: const ListTileThemeData(iconColor: saffron),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: maroon,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: DividerThemeData(color: Colors.black.withValues(alpha: 0.08), thickness: 1),
  );
}
