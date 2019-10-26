import 'dart:io';

import 'package:e2_design/models/onboarding_response.dart';
import 'package:e2_design/models/post_response.dart';
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
