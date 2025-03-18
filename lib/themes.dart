import "package:flutter/material.dart";

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
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
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
  );
}
