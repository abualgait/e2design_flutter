import 'dart:convert';

import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/constvalue/const_value.dart';
import 'package:e2_design/models/request/signup_request.dart';
import 'package:e2_design/models/signup_response.dart';
import 'package:e2_design/models/user_data_response.dart';
import 'package:e2_design/repositories/base_repository.dart';
import 'package:e2_design/screens/auth/pincode.dart';
import 'package:e2_design/utils/Utils.dart';
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

  TextEditingController controller = TextEditingController();
  String thisText = "";
  BaseRepository _baseRepository;
  var showloader = false;

  @override
  void initState() {
    super.initState();
    _baseRepository = BaseRepository();
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
  BuildContext scafoldContext;
  bool _validate = false;

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
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                  "assets/icon/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 24.0),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Text(
                                "Login to access your account",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Stack(
                                  children: <Widget>[
                                    Card(
                                      elevation: 10,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16.0,
                                                            bottom: 16.0),
                                                    child: TextField(
                                                      controller: controller,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      ),
                                                      decoration:
                                                          new InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 25,
                                                                bottom: 25,
                                                                top: 25,
                                                                right: 25),
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        errorText: _validate
                                                            ? 'Value Can\'t Be Empty'
                                                            : null,
                                                        hintText:
                                                            'Enter Email or Mobile Number',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        controller.text.isEmpty
                                                            ? _validate = true
                                                            : _validate = false;
                                                      });
                                                      isOnline()
                                                          .then((onValue) {
                                                        if (onValue) {
                                                          if (!_validate) {
                                                            setState(() {
                                                              showloader = true;
                                                            });
                                                            checkValidations(
                                                                context);
                                                          } else {
                                                            setState(() {
                                                              showloader =
                                                                  false;
                                                            });
                                                            flushBarUtil(
                                                                context, "Oops!", "Internet Connections Lost", Icon(
                                                              Icons.not_interested,
                                                              color: Colors.red,
                                                            ));

                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ClipRRect(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    200.0)),
                                                        child: Container(
                                                          color: state
                                                              .themeData
                                                              .textTheme
                                                              .body1
                                                              .color,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Login",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                state.themeData.primaryColor),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  void checkValidations(BuildContext context) {
    this.thisText = controller.text;

    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(thisText);

    if (emailValid) {
      print("valid mail");
      signupWithEmail(thisText);
    } else if (_isNumeric(thisText)) {
      print("valid phone");
      signupWithPhone(thisText);
    } else {
      print("invalid");
      setState(() {
        showloader = false;
      });

      flushBarUtil(
          context, "Oops!", "Enter valid email of number", Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void signupWithEmail(String thisText) {
    SignUpRequest signUpEmailRequest = new SignUpRequest(
        email: thisText,
        phone: "",
        first_name: "",
        last_name: "",
        password: "");
    _baseRepository.signupWithEmail(signUpEmailRequest).then((onValue) {
      checkResponse(onValue);
    });
  }

  void signupWithPhone(String thisText) {
    SignUpRequest signUpRequest = new SignUpRequest(
        email: "",
        phone: thisText,
        first_name: "Mohamed phone",
        last_name: "abualgait",
        password: "123456789");
    _baseRepository.signupWithMobile(signUpRequest).then((onValue) {
      checkPhoneResponse(onValue);
    });
  }

  void checkResponse(SignUpResponse onValue) {
    SignUpResponse response = onValue;

    if (response.message != "") {
      print(response.message);

      var token = '${Constants.BREAER}' + '${response.token}';
      SharedPreferencesHelper.setSession(Constants.USERTOKEN, token);
      String user = jsonEncode(UserData.fromJson(response.userData.toJson()));
      SharedPreferencesHelper.setSession(Constants.USERDATA, user);

      SharedPreferencesHelper.setUserLoggedIn();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      //show status false and show message
      print(response.message);
    }
    setState(() {
      showloader = false;
    });
  }

  void checkPhoneResponse(SignUpResponse onValue) {
    SignUpResponse response = onValue;

    if (response.message != "") {
      print(response.message);
//
//      var token = '${Constants.BREAER}' + '${response.token}';
//      SharedPreferencesHelper.setSession(Constants.USERTOKEN, token);
//      String user = jsonEncode(UserData.fromJson(response.userData.toJson()));
//      SharedPreferencesHelper.setSession(Constants.USERDATA, user);
//
//      SharedPreferencesHelper.setUserLoggedIn();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinCodePage(response)),
      );
    } else {
      //show status false and show message
      print(response.message);
    }
    setState(() {
      showloader = false;
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
