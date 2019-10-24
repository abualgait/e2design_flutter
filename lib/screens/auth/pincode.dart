import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
  }

  var appbartitle = "";
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

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
                body: Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: Mc2lipper(),
                      child: Container(
                        color: state.themeData.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(

                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "Verfication code",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 24.0),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  "Please type the verfication",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                                Text(
                                  "code sent to +65 **** 8910",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Center(
                            child: PinCodeTextField(
                              pinBoxHeight: 60,
                              pinBoxWidth: 60,
                              autofocus: false,
                              controller: controller,
                              hideCharacter: false,
                              highlight: true,
                              highlightColor: Colors.blue,
                              defaultBorderColor:
                                  state.themeData.textTheme.body1.color,
                              hasTextBorderColor: Colors.green,
                              maxLength: pinLength,
                              hasError: hasError,
                              onTextChanged: (text) {
                                setState(() {
                                  hasError = false;
                                });
                              },
                              onDone: (text) {
                                print("DONE $text");
                              },
                              pinTextStyle: TextStyle(fontSize: 20.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                this.thisText = controller.text;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(200.0)),
                                child: Container(
                                  color: state.themeData.textTheme.body1.color,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Verify now",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  state.themeData.primaryColor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: state.themeData.primaryColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Resend code",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: state.themeData.primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height / 2);

    var firstEndPoint = Offset(size.width * .5, size.height / 2 - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height / 2 - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 80.0);
    var secondControlPoint = Offset(size.width * .75, size.height / 2 - 10);
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
