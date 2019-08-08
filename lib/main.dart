import 'package:e2_design/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'base_classes/shaerd_prefs_helper.dart';
import 'constvalue/const_value.dart';
import 'language_manager/AppLocalizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var isEnglish = true;
  var supportedLocale;
  String textValue = '';

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.subscribeToTopic("global");
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);

        print(" onMessage called ${(msg)}");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });

    SharedPreferencesHelper.setLanguageCode("ar");
    SharedPreferencesHelper.getLanguageCode().then((onValue) {
      if (onValue == "en") {
        this.isEnglish = true;
        supportedLocale = [Locale('en', 'US')];
      } else {
        this.isEnglish = false;
        supportedLocale = [Locale('ar', 'EG')];
      }

      print("isEnglish " + isEnglish.toString());
      setState(() {});
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      '100',
      "E2CHANNEL",
      "This is QnA Channel",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    if (Theme.of(context).platform == TargetPlatform.iOS) {

      await flutterLocalNotificationsPlugin.show(
          0, msg['aps']['alert']['title'],msg['aps']['alert']['title'], platform);
    } else {

      await flutterLocalNotificationsPlugin.show(
          0,  msg['notification']['title'], msg['notification']['body'], platform);
    }
  }



  update(String token) {
    SharedPreferencesHelper.setSession(Constants.TOKEN, token);
    textValue = token;
    print("token " + textValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // List all of the app's supported locales here
      supportedLocales: supportedLocale,
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
