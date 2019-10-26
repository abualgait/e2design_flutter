import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController fnameControler = TextEditingController();
  TextEditingController lnameControler = TextEditingController();
  TextEditingController dnameControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController dobControler = TextEditingController();
  TextEditingController mobileControler = TextEditingController();
  TextEditingController cityControler = TextEditingController();
  TextEditingController bloodtypeControler = TextEditingController();
  TextEditingController genderControler = TextEditingController();

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
                backgroundColor: state.themeData.backgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: Mclipper(),
                            child: Container(
                              width: screenWidth,
                              height: 350,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    "https://natgeo.imgix.net/factsheets/thumbnails/01-balance-of-nature.adapt.jpg?auto=compress,format&w=1600&h=900&fit=crop",
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/image_placeholder.png",
                                  fit: BoxFit.fill,
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                fadeInDuration: Duration(seconds: 1),
                                fadeOutDuration: Duration(seconds: 1),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 250,
                            left: 25,
                            child: Container(
                              width: 80,
                              height: 80,
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: screenWidth,
                          child: Column(
                            children: <Widget>[

                              Card(
                                child: new TextField(
                                  controller: dnameControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Display Name',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: emailControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: dobControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Date of birth',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: mobileControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Mobile',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: cityControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Home city',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: genderControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Gender',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Card(
                                child: new TextField(
                                  controller: bloodtypeControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Blood type',
                                    labelStyle: TextStyle(
                                        color: state
                                            .themeData.textTheme.body1.color),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .5, size.height - 50.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 80.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 30.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Mc2lipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, (size.height / 2) - 50);
    path.lineTo(size.width, (size.height / 2) + 50);
//    var controlpoint = Offset(35.0, size.height);
//    var endpoint = Offset(size.width / 2, size.height);
//
//    path.quadraticBezierTo(
//        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);
//
//    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
