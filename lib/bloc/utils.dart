import 'package:flutter/material.dart';

ThemeData kLightTheme(double fontSize) => buildLightTheme(fontSize);

ThemeData buildLightTheme(double fontSize) {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    accentColor: Colors.black,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: fontSize),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: fontSize),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: fontSize - 2.0),
    ),
  );
}

ThemeData kDarkTheme(double fontSize) => buildDarkTheme(fontSize);

ThemeData buildDarkTheme(double fontSize) {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Color(0xff323639),
    accentColor: Colors.blue,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: fontSize),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: fontSize),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: fontSize - 2.0),
    ),
  );
}
