import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _kLanguageCode = "language";
  static final String _kUserCode = "islogged";

  /// ------------------------------------------------------------
  /// Method that returns the user language code, 'en' if not set
  /// ------------------------------------------------------------
  static Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kLanguageCode) ?? 'en';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user language code
  /// ----------------------------------------------------------
  static Future<bool> setLanguageCode(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kLanguageCode, value);
  }

  static void setUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kUserCode, true);
  }

  static void setUserLoggedOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kUserCode, false);
  }
  static Future<bool> getUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_kUserCode)  ;
  }


  static Future<bool> setSession(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<String> getSession(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? "";
  }

  static Future<bool> setSessionDouble(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setDouble(key, value);
  }

  static Future<double> getSessionDouble(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(key) ?? "";
  }


}
