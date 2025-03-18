import "package:flutter/material.dart";

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3165A1),
      secondary: Color(0xFFA8A8A8),
    ),
    fontFamily: "Poppins",
    appBarTheme: appBarTheme(),
    dividerTheme: DividerThemeData(
      color: Colors.grey[500],
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    )
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
