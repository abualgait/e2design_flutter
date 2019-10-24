import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
  VoidCallback onTap;

  MainDrawer({this.onTap()});
}

class _MainDrawerState extends State<MainDrawer> {
  var _menuGridICons = [
    Icon(Icons.settings),
    Icon(Icons.person),
    Icon(Icons.history),
    Icon(Icons.notifications),
    Icon(Icons.info_outline),
    Icon(Icons.help_outline),
  ];

  var _menuGridTitles = [
    Text("Settings"),
    Text("Profile"),
    Text("Activites"),
    Text("Notifications"),
    Text("Bio"),
    Text("Help"),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: new Container(
              color: Colors.white,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new IconButton(
                      onPressed: widget.onTap,
                      icon: Icon(Icons.close),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 70,
                                height: 70,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("Muhammad"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("abualgaitad@gmail.com"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                  new Divider(),
                  Column(
                    children: <Widget>[
                      menuRow(0, _menuGridICons, _menuGridTitles),
                      menuRow(2, _menuGridICons, _menuGridTitles),
                      menuRow(4, _menuGridICons, _menuGridTitles),
                    ],
                  ),
                  Row(
                    children: <Widget>[

                    ],
                  ),
                  //have an idea, great talk to us
                  Row(children: <Widget>[

                  ]),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("ver 1.0"),
                        IconButton(
                          onPressed: null,
                          icon: Icon(Icons.exit_to_app),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
