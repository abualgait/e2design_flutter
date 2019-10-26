import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/constvalue/const_value.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.getSession(Constants.IS_DARK_MODE).then((onValue) {
      if (onValue == "true") {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }

      setState(() {});
    });

    SharedPreferencesHelper.getSessionDouble(Constants.kTextSize)
        .then((onValue) {
      text_size = onValue;
      setState(() {});
    });
  }

  var text_size = 8.0;
  var isDarkMode = false;
  var languages = ["English", "Arabic"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        body: BlocBuilder(
          bloc: changeThemeBloc,
          builder: (BuildContext context, ChangeThemeState state) {
            return Theme(
                data: state.themeData,
                child: Scaffold(
                  appBar: buildMainAppBar(
                      state,
                      true,
                      false,
                      context,
                      AppLocalizations.of(context).translate('app_settings'),
                      state.themeData.textTheme.headline,
                      state.themeData.primaryColor),
                  body: SafeArea(
                    child: Container(
                      color: state.themeData.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Text(
                                "Language",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return BlocBuilder(
                                          bloc: changeThemeBloc,
                                          builder: (BuildContext context,
                                              ChangeThemeState state) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  state.themeData.primaryColor,
                                              title: Text(
                                                'Change Language',
                                                style: state
                                                    .themeData.textTheme.body1,
                                              ),
                                              content: SizedBox(
                                                height: 100,
                                                child: Center(
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: 2,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        height: 50,
                                                        child: InkWell(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                languages[
                                                                    index],
                                                                style: state
                                                                    .themeData
                                                                    .textTheme
                                                                    .body2),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              switch (index) {
                                                                case 0:
                                                                  SharedPreferencesHelper
                                                                      .setLanguageCode(
                                                                          "en");

                                                                  break;
                                                                case 1:
                                                                  SharedPreferencesHelper
                                                                      .setLanguageCode(
                                                                          "ar");
                                                                  break;
                                                              }
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MyApp()),
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  color: state.themeData.primaryColor,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("English(US)"),
                                        Icon(
                                          Icons.navigate_next,
                                          color: state.themeData.accentColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Text Size"),
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                elevation: 5,
                                color: state.themeData.primaryColor,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "A",
                                        style: TextStyle(fontSize: 8),
                                      ),
                                      Slider(
                                        onChanged: (onValue) {
                                          setState(() {
                                            text_size = onValue;

                                            SharedPreferencesHelper
                                                .setSessionDouble(
                                                    Constants.kTextSize,
                                                    text_size);
                                            SharedPreferencesHelper.getSession(
                                                    Constants.IS_DARK_MODE)
                                                .then((onValue) {
                                              if (onValue == "true") {
                                                changeThemeBloc
                                                    .onDarkThemeChange(
                                                        text_size);
                                              } else {
                                                changeThemeBloc
                                                    .onLightThemeChange(
                                                        text_size);
                                              }
                                            });
                                          });
                                        },
                                        value: text_size,
                                        min: 8,
                                        max: 16,
                                      ),
                                      Text(
                                        "A",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 5,
                                color: state.themeData.primaryColor,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Dark Mode",
                                      ),
                                      Switch(
                                          onChanged: (onValue) {
                                            switch (onValue) {
                                              case true:
                                                isDarkMode = true;
                                                SharedPreferencesHelper
                                                    .setSession(
                                                        Constants.IS_DARK_MODE,
                                                        "true");

                                                changeThemeBloc
                                                    .onDarkThemeChange(
                                                        text_size);
                                                break;
                                              case false:
                                                isDarkMode = false;
                                                SharedPreferencesHelper
                                                    .setSession(
                                                        Constants.IS_DARK_MODE,
                                                        "false");
                                                changeThemeBloc
                                                    .onLightThemeChange(
                                                        text_size);
                                                break;
                                            }
                                          },
                                          value: isDarkMode)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Account"),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Email"),
                              Card(
                                elevation: 5,
                                color: state.themeData.primaryColor,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("abualgait@gmail.com"),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Mobile"),
                              Card(
                                elevation: 5,
                                color: state.themeData.primaryColor,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("0123456789"),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}
