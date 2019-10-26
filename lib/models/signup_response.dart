import 'package:e2_design/models/user_data_response.dart';

import 'normal_response.dart';

class SignUpResponse extends NormalResponse {
  String token;
  String token_expression;
  UserData userData;

  SignUpResponse(int next_offset, bool status, String message, this.token,
      this.token_expression, this.userData)
      : super(next_offset, status, message);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return SignUpResponse(
        normalresponse.next_offset,
        normalresponse.status,
        normalresponse.message,
        json['token'],
        json['token_expression'],
        UserData.fromJson(json['data']));
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['token'] = token;
    map['token_expression'] = token_expression;
    map['data'] = userData;

    return map;
  }

//  // Extract a Note object from a Map object
//  SignUpResponse.fromMapObject(Map<String, dynamic> map) {
//    this.token = map['token'];
//    this.token_expression = map['token_expression'];
//  }
}
