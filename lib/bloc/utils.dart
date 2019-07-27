import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
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
          fontSize: 12),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 12),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 10),
    ),
  );
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Color(0xff323639),
    accentColor: Colors.blue,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 12),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 12),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 10),
    ),
  );
}
