import 'package:e2_design/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'base_classes/shaerd_prefs_helper.dart';
import 'language_manager/AppLocalizations.dart';
import 'dart:developer';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isEnglish = 'en';

  @override
  void initState() {
    super.initState();

      SharedPreferencesHelper.getLanguageCode().then((onValue) {
        this.isEnglish = onValue;

        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // List all of the app's supported locales here
      supportedLocales: isEnglish == 'en'
          ? [
              Locale('en', 'US'),
            ]
          : [
              Locale('ar', 'EG'),
            ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      debugShowCheckedModeBanner: true,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { GUEST_MODE, LOGGED_IN }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.GUEST_MODE;
  String _userId = "";
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesHelper.getUserLoggedIn().then((onValue) {
      setState(() {
        this.isLoggedIn = onValue;
      });
    });
    if (isLoggedIn) {
      return new HomePage();
    } else {
      return new HomePage();
    }
  }
}
