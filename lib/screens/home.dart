import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_new_post_page.dart';
import 'main_drawer.dart';
import 'main_page.dart';
import 'notification_page.dart';

enum SCREENS { MAINBODY, NOTIFICATIONS, ACTIVITES, BIO, HELP, PROFILE }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var pageIndex = 0;
  PageController pageController = PageController();
  int _showMenuIndex = 0;
  Animation<double> animation;
  AnimationController controller;

  bool isCollapsed = true;
  bool isRTL = false;
  double screenWidth, screenHeight;
  Duration duration = new Duration(microseconds: 300);
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;
  Animation<double> _menuScaleAnimation;
  int currentPage = 0;
  PageController _controller;

  Widget indexpage;

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
    _animationController = AnimationController(duration: duration, vsync: this);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.5, 0))
        .animate(_animationController);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_animationController);
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
  var appbartitle = "E2Design";

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
                body: Stack(
                  children: <Widget>[PageMenu(), MasterPage()],
                ),
              ));
        });
  }

  void setIndexPage(SCREENS screens) {
    switch (screens) {
      case SCREENS.MAINBODY:
        indexpage = MainBody();
        break;
      case SCREENS.NOTIFICATIONS:
        indexpage = NotificationPage();
        break;
      case SCREENS.ACTIVITES:
        indexpage = MainDrawer();
        break;
      case SCREENS.BIO:
        indexpage = NotificationPage();
        break;
      case SCREENS.HELP:
        indexpage = NotificationPage();
        break;
      case SCREENS.PROFILE:
        indexpage = MainBody();
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
//    setState(() {
//      controller.forward();
//      _showMenuIndex = 1;
//    });

    setState(() {
      if (isCollapsed)
        _animationController.forward();
      else
        _animationController.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  void _onClossedMenu() {
    setState(() {
      controller.reverse();
      _showMenuIndex = 0;
    });
  }

  Widget MasterPage() {
    if (firstTime) setIndexPage(SCREENS.MAINBODY);
    var screen = MediaQuery.of(context).size;
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
//              top: isCollapsed ? 0 : screen.height * 0.1,
//              bottom: isCollapsed ? 0 : screen.height * 0.1,
        left:
            isCollapsed ? 0 : isRTL ? screen.width * -0.5 : screen.width * 0.5,
        right:
            isCollapsed ? 0 : isRTL ? screen.width * 0.5 : screen.width * -0.5,
        child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              animationDuration: duration,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              elevation: 8,
              child: BlocBuilder(
                bloc: changeThemeBloc,
                builder: (BuildContext context, ChangeThemeState state) {
                  return Theme(
                    data: state.themeData,
                    child: Scaffold(
                      body: Container(
                        color: state.themeData.primaryColor,
                        child: PageView(
                            physics: BouncingScrollPhysics(),
                            controller: pageController,
                            onPageChanged: onPageChanged,
                            children: <Widget>[indexpage]),
                      ),
                      appBar: AppBar(
                        centerTitle: true,
                        elevation: 5,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TitleImageWidget(state, indexpage)
                          ],
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
                        backgroundColor: Colors.pink,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewPostPage()),
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
            )));
  }

  Widget TitleImageWidget(ChangeThemeState state, indexpage) {
    if (appbartitle == "TimeLine") {
      return Image.asset("assets/icon/logo.png");
    } else {
      return Text(
//                              AppLocalizations.of(context)
//                                  .translate('app_title'),
        appbartitle,
        //"E2 Design",
        style: state.themeData.textTheme.headline,
      );
    }
  }

  Widget PageMenu() {
    return Container(
      color: Color.fromRGBO(0, 65, 109, 108),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            new Container(
                width: 60.0,
                height: 60.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")))),
            SizedBox(
              height: 15,
            ),
            Text(
              "Muhammad Sayed",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Cairo, Egypt",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.MAINBODY);
                      appbartitle = "TimeLine";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Timline",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.NOTIFICATIONS);
                      appbartitle = "Notifications";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 5),
                Container(
                  height: 5,
                  width: 5,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.MAINBODY);
                      appbartitle = "Activites";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Activites",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.MAINBODY);
                      appbartitle = "Bio";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Bio",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.MAINBODY);
                      appbartitle = "Help";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.help,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Help",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      firstTime = false;
                      setIndexPage(SCREENS.MAINBODY);
                      appbartitle = "Profile";
                      _onPressedMenu();
                    });
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Spacer(
              flex: 3,
            ),
            Row(
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
                          _onPressedMenu();
                        });
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(color: Colors.white),
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Log out",
                      style: TextStyle(color: Colors.white),
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
    );
  }
}
