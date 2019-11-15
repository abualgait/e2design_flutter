import 'dart:convert';

import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/constvalue/const_value.dart';
import 'package:e2_design/models/normal_response.dart';
import 'package:e2_design/models/signup_response.dart';
import 'package:e2_design/models/user_data_response.dart';
import 'package:e2_design/repositories/base_repository.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'login.dart';

class PinCodePage extends StatefulWidget {
  SignUpResponse response;

  PinCodePage(this.response);

  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  double screenWidth, screenHeight;
  BaseRepository _baseRepository;
  var showloader = false;

  @override
  void initState() {
    super.initState();

    _baseRepository = BaseRepository();
  }

  var appbartitle = "";
  TextEditingController controller = TextEditingController();
  TextEditingController temp_controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      body: BlocBuilder(
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
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 140,
                                    ),
                                    Text(
                                      "Verfication code",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 24.0),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Please type the verfication",
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "code sent to",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.response.userData
                                                  .phone_number,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                      ProvidedPinBoxTextAnimation
                                          .scalingTransition,
                                  pinTextAnimatedSwitcherDuration:
                                      Duration(milliseconds: 300),
                                ),
                              ),
                              Text(widget.response.userData.verification_code),
                              TextField(
                                controller: temp_controller,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                                decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  contentPadding: EdgeInsets.only(
                                      left: 25, bottom: 25, top: 25, right: 25),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Enter Code(testing only)',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showloader = true;

                                    print("comming code");
                                    print(widget
                                        .response.userData.verification_code);
                                    this.thisText = temp_controller.text;
                                    if (thisText ==
                                        widget.response.userData
                                            .verification_code) {
                                      isOnline().then((onValue) {
                                        if (onValue) {
                                          checkValidation(context, thisText);
                                        } else {

                                          flushBarUtil(
                                              context, "Oops!", "Internet Connection Lost", Icons.close);
                                        }
                                      });
                                    } else {
                                      print("invalid code");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                      );
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(200.0)),
                                    child: Container(
                                      color:
                                          state.themeData.textTheme.body1.color,
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
                                                  color: state
                                                      .themeData.primaryColor),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color:
                                                  state.themeData.primaryColor,
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
                      ),
                      Visibility(
                        child: Center(child: CircularProgressIndicator()),
                        visible: showloader,
                      )
                    ],
                  ),
                ));
          }),
    );
  }

  void checkValidation(BuildContext context, String code) {
    verifyPhoneNumber(code);
//    var token = '${Constants.BREAER}' + '${widget.response.token}';
//    SharedPreferencesHelper.setSession(Constants.USERTOKEN, token);
//    String user =
//    jsonEncode(UserData.fromJson(widget.response.userData.toJson()));
//    SharedPreferencesHelper.setSession(Constants.USERDATA, user);
//
//    SharedPreferencesHelper.setUserLoggedIn();
//    Navigator.pushNamedAndRemoveUntil(context, "/landing", (r) => false);
//
  }

  void verifyPhoneNumber(String code) {
    _baseRepository.verifyPhoneNumber(code).then((onValue) {
      checkResponse(onValue);
    });
  }

  void checkResponse(NormalResponse onValue) {
    NormalResponse response = onValue;

    if (response.message != "") {
      print(response.message);
      var token = '${Constants.BREAER}' + '${widget.response.token}';
      SharedPreferencesHelper.setSession(Constants.USERTOKEN, token);
      String user =
          jsonEncode(UserData.fromJson(widget.response.userData.toJson()));
      SharedPreferencesHelper.setSession(Constants.USERDATA, user);

      SharedPreferencesHelper.setUserLoggedIn();
      Navigator.pushNamedAndRemoveUntil(context, "/landing", (r) => false);
    } else {
      //show status false and show message
      print(response.message);
    }
    setState(() {
      showloader = false;
    });
  }
}

/*    var token = '${Constants.BREAER}' +
                                      '${widget.response.token}';
                                  SharedPreferencesHelper.setSession(
                                      Constants.USERTOKEN, token);
                                  String user = jsonEncode(UserData.fromJson(
                                      widget.response.userData.toJson()));
                                  SharedPreferencesHelper.setSession(
                                      Constants.USERDATA, user);

                                  SharedPreferencesHelper.setUserLoggedIn();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                              */
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
