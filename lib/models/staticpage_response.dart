import 'normal_response.dart';

class StaticResponse extends NormalResponse {
  StaticPage data;

  StaticResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory StaticResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return StaticResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, StaticPage.fromJson(json['data']));
  }
}

class StaticPage {
  String id;
  String uid;
  String page_title;
  String page_image;
  String page_text;
  String created_at;
  String updatedAt;
  int __v;

  StaticPage.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    uid = json['uid'];
    page_title = json['page_title'];
    page_image = json['page_image'];
    page_text = json['page_text'];
    created_at = json['created_at'];
    updatedAt = json['updatedAt'];
    __v = json['__v'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['uid'] = uid;
    map['page_title'] = page_title;
    map['page_image'] = page_image;
    map['page_text'] = page_text;
    map['created_at'] = created_at;
    map['updatedAt'] = updatedAt;
    map['__v'] = __v;

    return map;
  }

  // Extract a Note object from a Map object
  StaticPage.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.uid = map['uid'];
    this.page_title = map['page_title'];
    this.page_image = map['page_image'];
    this.page_text = map['page_text'];
    this.created_at = map['created_at'];
    this.updatedAt = map['updatedAt'];
    this.__v = map['__v'];
  }
}
