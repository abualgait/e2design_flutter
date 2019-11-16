import 'package:e2_design/utils/Utils.dart';

import 'normal_response.dart';

class UserDataResponse extends NormalResponse {
  UserData totalResults;
  UserData data;

  UserDataResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return UserDataResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, UserData.fromJson(json['data']));
  }
}

class UserData {
  final String phone_number;
  final String email;
  final String id;
  final String password;
  final String first_name;
  final String last_name;
  final bool verified;
  final String verification_code;
  final String createdAt;
  final String updatedAt;
  final String v;
  final List<String> tags;

  UserData({
    this.phone_number,
    this.email,
    this.id,
    this.password,
    this.first_name,
    this.last_name,
    this.verified,
    this.verification_code,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.tags,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      phone_number: json['phone_number'],
      email: json['email'],
      id: json['_id'],
      password: json['password'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      verified: json['verified'],
      verification_code: json['verification_code'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['v'],
      tags: getListStringsFromDynamic(json['tags']),
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["_id"] = id;
    map["phone_number"] = phone_number;
    map["email"] = email;
    map["password"] = password;
    map["first_name"] = first_name;
    map["last_name"] = last_name;
    map["verified"] = verified;
    map["verification_code"] = verification_code;
    map["createdAt"] = createdAt;
    map["v"] = v;
    map["tags"] = tags;

    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "phone_number": this.phone_number,
      "email": this.email,
      "password": this.password,
      "first_name": this.first_name,
      "last_name": this.last_name,
      "verified": this.verified,
      "verification_code": this.verification_code,
      "createdAt": this.createdAt,
      "v": this.v,
      "tags": this.tags,
    };
  }
}
