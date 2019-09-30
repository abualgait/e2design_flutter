import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_post_page.dart';
import 'main_drawer.dart';
import 'main_page.dart';
import 'notification_page.dart';

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

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _showMenuIndex,
      children: <Widget>[
        BlocBuilder(
          bloc: changeThemeBloc,
          builder: (BuildContext context, ChangeThemeState state) {
            return Theme(
              data: state.themeData,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 5,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('app_title'),
                        //"E2 Design",
                        style: state.themeData.textTheme.headline,
                      )
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
                        icon: Icon(Icons.notifications),
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
                body: Container(
                  color: state.themeData.primaryColor,
                  child: PageView(
                      physics: BouncingScrollPhysics(),
                      controller: pageController,
                      onPageChanged: onPageChanged,
                      children: <Widget>[MainBody()]),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPostPage()),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            );
          },
        ),
        FadeTransition(
          child: MainDrawer(
            onTap: _onClossedMenu,
          ),
          opacity: animation,
        )
      ],
    );
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
      controller.forward();
      _showMenuIndex = 1;
    });
  }

  void _onClossedMenu() {
    setState(() {
      controller.reverse();
      _showMenuIndex = 0;
    });
  }
}
