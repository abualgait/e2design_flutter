import 'package:e2_design/bloc/utils.dart';
import 'package:flutter/material.dart';

class ChangeThemeState {
  final ThemeData themeData;

  ChangeThemeState({@required this.themeData});

  factory ChangeThemeState.lightTheme(double fontSize) {

    return ChangeThemeState(themeData: kLightTheme(fontSize));
  }

  factory ChangeThemeState.darkTheme(double fontSize) {
    return ChangeThemeState(themeData: kDarkTheme(fontSize));
  }
}
