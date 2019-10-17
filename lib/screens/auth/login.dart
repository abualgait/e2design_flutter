import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRTL = false;
  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.getLanguageCode().then((onValue) {
      if (onValue == "en") {
        isRTL = false;
      } else {
        isRTL = true;
      }

      setState(() {});
    });
  }

  var appbartitle = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    List<Widget> actions = [];
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Theme(
              data: state.themeData,
              child: Scaffold(
//                appBar: buildMainAppBarWithActions(
//                    state,
//                    true,
//                    false,
//                    context,
//                    AppLocalizations.of(context).translate('app_login'),
//                    state.themeData.textTheme.headline,
//                    state.themeData.primaryColor,
//                    actions),
                backgroundColor: Colors.white10,
                body: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        "assets/images/worldmap.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            "assets/icon/logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: state.themeData.primaryColor,
                                      fontSize: 18.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Hello There!",
                                  style: TextStyle(
                                      color: state.themeData.primaryColor,
                                      fontSize: 18.0),
                                ),
                                Text(
                                  "Welcome back",
                                  style: TextStyle(
                                      color: state.themeData.primaryColor,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintStyle:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                              hintText: 'Mobile Number or Email'),
                        ),
                        GestureDetector(
                          onTap: () {
                            SharedPreferencesHelper.setUserLoggedIn();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.redAccent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
