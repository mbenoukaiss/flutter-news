import "package:flutter/material.dart";

const primary = Color(0xFF3165A1);

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: Color(0xFFA8A8A8),
    ),
    fontFamily: "Poppins",
    appBarTheme: appBarTheme(),
    dividerTheme: DividerThemeData(
      color: Colors.grey[500],
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color.lerp(Colors.white, primary, 0.05),
      selectedColor: primary,
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(color: primary),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: primary, width: 0.3),
      ),
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    ),
  );
}
