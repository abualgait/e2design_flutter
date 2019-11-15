import 'dart:io';

import 'package:e2_design/models/onboarding_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Post> getListFromDynamic(List<dynamic> dynamicList) {
  List<Post> results;
  if (dynamicList != null) {
    results = new List<Post>();
    dynamicList.forEach((v) {
      results.add(new Post.fromJson(v));
    });
  }
  return results;
}

List<OnBoard> getListOnBoardFromDynamic(List<dynamic> dynamicList) {
  List<OnBoard> results;
  if (dynamicList != null) {
    results = new List<OnBoard>();
    dynamicList.forEach((v) {
      results.add(new OnBoard.fromJson(v));
    });
  }
  return results;
}

List<String> getListStringsFromDynamic(List<dynamic> dynamicList) {
  List<String> results;
  if (dynamicList != null) {
    results = new List<String>();
    dynamicList.forEach((v) {
      results.add(v);
    });
  }
  return results;
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

showMessage(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(message),
  ));
}

flushBarUtil(BuildContext context, String title, String message, IconData icon) {
  Flushbar(
    title: title,
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    boxShadows: [
      BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    backgroundGradient: LinearGradient(colors: [
      Color(0xff614385),
      Color(0xff516395),
    ]),
    isDismissible: true,
    duration: Duration(seconds: 4),
    icon: Icon(
      icon,
      color: Colors.greenAccent,
    ),
  )..show(context);
}


flushBarUtilWidget(BuildContext context, String title, Widget message, IconData icon) {
  Flushbar(
    title: title,
    messageText: message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    boxShadows: [
      BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    backgroundGradient: LinearGradient(colors: [
      Color(0xff614385),
      Color(0xff516395),
    ]),
    isDismissible: true,
    duration: Duration(seconds: 4),
    icon: Icon(
      icon,
      color: Colors.greenAccent,
    ),
  )..show(context);
}
