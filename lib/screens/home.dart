import 'dart:convert';

import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/constvalue/const_value.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/user_data_response.dart';
import 'package:e2_design/screens/settings_page.dart';
import 'package:e2_design/screens/staticpages/help_page.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'activities_page.dart';
import 'add_new_post_page.dart';
import 'auth/profile.dart';
import 'main_page.dart';
import 'notification_page.dart';

enum SCREENS { MAINBODY, NOTIFICATIONS, ACTIVITES, BIO, HELP, PROFILE }

abstract class IsReload {
  void reloadData();
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var pageIndex = 0;
  PageController pageController = PageController();
  int _showMenuIndex = 0;

//  Animation<double> animation;
//  AnimationController controller;

//  bool isCollapsed = true;
  bool isRTL = false;
  double screenWidth, screenHeight;

  // Duration duration = new Duration(microseconds: 300);
//  AnimationController _animationController;
//  Animation<double> _scaleAnimation;
//  Animation<Offset> _slideAnimation;
//  Animation<double> _menuScaleAnimation;
  int currentPage = 0;
  PageController _controller;

  Widget indexpage;

  UserData userData;

  @override
  void initState() {
    super.initState();

    SharedPreferencesHelper.getSession(Constants.USERDATA).then((onValue) {
      Map userMap = jsonDecode(onValue);
      var user = UserData.fromJson(userMap);
      //you got user fill layout
      this.userData = user;
    });

    SharedPreferencesHelper.getLanguageCode().then((onValue) {
      if (onValue == "en") {
        isRTL = false;
      } else {
        isRTL = true;
      }

      setState(() {});
    });
//    controller = AnimationController(
//        duration: const Duration(milliseconds: 200), vsync: this);
//    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

//    _animationController = AnimationController(duration: duration, vsync: this);
//    _scaleAnimation =
//        Tween<double>(begin: 1, end: 0.8).animate(_animationController);
//    _slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.5, 0))
//        .animate(_animationController);
//    _menuScaleAnimation =
//        Tween<double>(begin: 0.5, end: 1).animate(_animationController);
    _controller = PageController(
      initialPage: currentPage,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  var firstTime = true;
  var appbartitle = "TimeLine";
  bool isReload = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Theme(
              data: state.themeData,
              child: Scaffold(
                  backgroundColor: Colors.white10,
                  body: Center(
                      child: IndexedStack(
                    index: _showMenuIndex,
                    children: <Widget>[MasterPage(state), PageMenu(state)],
                  ))));
        });
  }

  void setIndexPage(SCREENS screens) {
    switch (screens) {
      case SCREENS.MAINBODY:
        indexpage = MainBody(isReload);
        break;
      case SCREENS.NOTIFICATIONS:
        indexpage = NotificationPage();
        break;
      case SCREENS.ACTIVITES:
        indexpage = ActivityPage();
        break;
      case SCREENS.BIO:
        indexpage = NotificationPage();
        break;
      case SCREENS.HELP:
        indexpage = HelpPage();
        break;
      case SCREENS.PROFILE:
        indexpage = ProfilePage();
        break;
    }
  }

  void onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  void navigationTapped(int value) {
    pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPressedMenu() {
    setState(() {
      //controller.forward();
      _showMenuIndex = 1;
    });

//    setState(() {
//      if (isCollapsed)
//        _animationController.forward();
//      else
//        _animationController.reverse();
//
//      isCollapsed = !isCollapsed;
//    });
  }

  void _onClossedMenu() {
    setState(() {
      // controller.reverse();
      _showMenuIndex = 0;
    });
  }

  Widget MasterPage(ChangeThemeState state) {
    if (firstTime) setIndexPage(SCREENS.MAINBODY);
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      elevation: 20,
      child: BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Theme(
            data: state.themeData,
            child: Scaffold(
              body: Container(
                  color: state.themeData.primaryColor, child: indexpage
//                PageView(
//                    physics: BouncingScrollPhysics(),
//                    controller: pageController,
//                    onPageChanged: onPageChanged,
//                    children: <Widget>[indexpage]),
                  ),
              appBar: AppBar(
                centerTitle: true,
                elevation: 5,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[TitleImageWidget(state, indexpage)],
                ),
                backgroundColor: state.themeData.primaryColor,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: _onPressedMenu,
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.notifications_none),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()),
                        );
                      },
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: state.themeData.textTheme.body1.color,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewPostPage(() => {
                              setState(() {
                                flushBarUtilWidget(
                                    context,
                                    "Thank you!",
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Your answer means a lot",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "you got 10 points",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                    Icons.check);

                                firstTime = true;
                                isReload = true;
                                setIndexPage(SCREENS.MAINBODY);
                                appbartitle = "TimeLine";
                                _onClossedMenu();
                              })
                            })),
                  );
                },
                child: Text(
                  "&",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget TitleImageWidget(ChangeThemeState state, indexpage) {
//    if (appbartitle == "TimeLine") {
//      return Image.asset("assets/icon/logo.png");
//    } else {
    return Text(
//                              AppLocalizations.of(context)
//                                  .translate('app_title'),
      appbartitle,
      //"E2 Design",
      style: TextStyle(
          color: state.themeData.textTheme.body1.color,
          fontStyle: state.themeData.textTheme.body1.fontStyle,
          fontSize: 13),
    );
    // }
  }

  var isVisisble = false;

  Widget PageMenu(ChangeThemeState state) {
    //var displayName = userData.first_name + userData.last_name;
    return SafeArea(
      child: Container(
        // color: state.themeData.primaryColor,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xff614385),
              Color(0xff516395),
            ])),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")))),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Muhammad",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Cairo, Egypt",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new IconButton(
                    onPressed: _onClossedMenu,
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              //progress user data
              Column(
                children: <Widget>[
                  SizedBox(
                      child: Column(
                    children: <Widget>[
                      new LinearPercentIndicator(
                        lineHeight: 14.0,
                        percent: 0.70,
                        center: Text(
                          "70.0%",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        backgroundColor: Colors.grey,
                        progressColor: Colors.yellowAccent,
//              leading:  new Text("Golden",style: TextStyle(fontSize: 10),),
//              trailing: new Text("Diamond",style: TextStyle(fontSize: 10),),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 7,
                                  width: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      color: Colors.yellowAccent,
                                    ),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Golden",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 7,
                                  width: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      color: Colors.grey,
                                    ),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Diamond",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[Text("129"), Text("Questions")],
                        ),
                        Column(
                          children: <Widget>[Text("98%"), Text("Accurate")],
                        ),
                        Column(
                          children: <Widget>[Text("450"), Text("Answers")],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.MAINBODY);
                                appbartitle = "TimeLine";
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.dashboard,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Timline",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.NOTIFICATIONS);
                                appbartitle = "Notifications";
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Notifications",
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.ACTIVITES);
                                appbartitle = AppLocalizations.of(context)
                                    .translate('app_activities');
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.history,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Activites",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.MAINBODY);
                                appbartitle = "Bio";
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Bio",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.HELP);
                                appbartitle = "Help";
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.help,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Help",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                firstTime = false;
                                setIndexPage(SCREENS.PROFILE);
                                appbartitle = "Profile";
                                _onClossedMenu();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Profile",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            //invite a friend and get 100 points
                            child: buildFlatButtonWidget(state,
                                "invite a friend and get 100 points", 10)),
                      ],
                    ),
                    //have an idea, great talk to us
                    Row(children: <Widget>[
                      Expanded(
                          child: buildFlatButtonWidget(
                              state, "have an idea, great talk to us", 10)),
                    ]),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()),
                            );
                            _onClossedMenu();
                          });
                        },
                        icon: Icon(
                          Icons.settings,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Settings",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 1.5,
                    height: 20,
                    child: Container(
                      color: state.themeData.textTheme.body1.color,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _onClossedMenu();
                          });

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
                                        'Logout',
                                        style: TextStyle(
                                            color: state.themeData.textTheme
                                                .body1.color,
                                            fontStyle: state.themeData.textTheme
                                                .body1.fontStyle,
                                            fontSize: 17),
                                      ),
                                      content: SizedBox(
                                        height: 90,
                                        child: Center(
                                            child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Are you sure you want to logout?",
                                              style: TextStyle(
                                                  color: state.themeData
                                                      .textTheme.body1.color,
                                                  fontStyle: state
                                                      .themeData
                                                      .textTheme
                                                      .body1
                                                      .fontStyle,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: InkWell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                            child: Text(
                                                              "Yes",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: state
                                                                      .themeData
                                                                      .textTheme
                                                                      .body1
                                                                      .color,
                                                                  fontStyle: state
                                                                      .themeData
                                                                      .textTheme
                                                                      .body1
                                                                      .fontStyle,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          SharedPreferencesHelper
                                                              .setUserLoggedOut();
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  "/root",
                                                                  (r) => false);
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Center(
                                                          child: Text(
                                                            "No",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                color: state
                                                                    .themeData
                                                                    .textTheme
                                                                    .body1
                                                                    .color,
                                                                fontStyle: state
                                                                    .themeData
                                                                    .textTheme
                                                                    .body1
                                                                    .fontStyle,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      ),
                                    );
                                  });
                            },
                          );
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Log out",
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
