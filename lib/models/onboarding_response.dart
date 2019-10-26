import 'dart:ui';

import 'package:e2_design/utils/Utils.dart';

import 'normal_response.dart';

class OnBoardingResponse extends NormalResponse {
  List<OnBoard> totalResults;
  List<OnBoard> results;


  OnBoardingResponse(int next_offset, bool status, String message, this.results )
      : super(next_offset, status, message);

  factory OnBoardingResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return OnBoardingResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, getListOnBoardFromDynamic(json['data']) );
  }
}

class OnBoard {

  String id;
  String uid;
  String quote;
  String lang;
  String image;
  String created_at;



   OnBoard.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    uid = json['uid'];
    quote = json['quote'];
    lang = json['lang'];
    image = json['image'];
    created_at = json['created_at'];

  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['uid'] = uid;
    map['quote'] = quote;
    map['lang'] = lang;
    map['image'] = image;
    map['created_at'] = created_at;


    return map;
  }

  // Extract a Note object from a Map object
  OnBoard.fromMapObject(Map<String, dynamic> map) {

    this.id = map['id'];
    this.uid = map['uid'];
    this.quote = map['quote'];
    this.lang = map['lang'];
    this.image = map['image'];
    this.created_at = map['created_at'];

  }
}
