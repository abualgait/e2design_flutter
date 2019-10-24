import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:flutter/material.dart';

ThemeData kLightTheme(double fontSize) => buildLightTheme(fontSize);
var fontFamilty = "GoogleSans";

ThemeData buildLightTheme(double fontSize) {
  SharedPreferencesHelper.getLanguageCode().then((onValue) {
    if (onValue == "en") {
      fontFamilty = "GoogleSans";
    } else {
      fontFamilty = "GE";
    }
  });

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    primaryColorDark: Colors.white,
    backgroundColor: Colors.white70,
    accentColor: Colors.blueAccent,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: fontSize),
      body1: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: fontSize),
      body2: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: fontSize - 2.0),
    ),
  );
}

ThemeData kDarkTheme(double fontSize) => buildDarkTheme(fontSize);

ThemeData buildDarkTheme(double fontSize) {
  SharedPreferencesHelper.getLanguageCode().then((onValue) {
    if (onValue == "en") {
      fontFamilty = "GoogleSans";
    } else {
      fontFamilty = "Sans";
    }
  });
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Color(0xff323639),
    accentColor: Colors.blueAccent,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: fontSize),
      body1: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: fontSize),
      body2: TextStyle(
          fontFamily: fontFamilty,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: fontSize - 2.0),
    ),
  );
}
