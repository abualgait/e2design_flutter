import 'package:flutter/material.dart';

abstract class Styles {
  static const headlineText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const minorText = TextStyle(
    color: Color.fromRGBO(128, 128, 128, 1),
    fontFamily: 'NotoSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const headlineName = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.9),
    fontFamily: 'NotoSans',
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const headlineDescription = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const cardTitleText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.9),
    fontFamily: 'NotoSans',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

}
