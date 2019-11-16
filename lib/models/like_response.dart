
import 'normal_response.dart';

class LikeResponse extends NormalResponse {
  MyLike data;

  LikeResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return LikeResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, new MyLike.fromJson(json['data']));
  }
}


class MyLike {
  String _id;
  String uid;
  String user;
  String question;
  String createdAt;
  String updatedAt;

  int v;

  String get id => _id;

  MyLike.fromJson(Map<String, dynamic> json) {
    //_id = json['_id'];
    _id = json['_id'];
    uid = json['uid'];
    user = json['user'];
    question = json['question'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['_id'] = _id;
    }
    map['uid'] = uid;
    map['user'] = user;
    map['question'] = question;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;

    map['__v'] = v;

    return map;
  }

  // Extract a Note object from a Map object
  MyLike.fromMapObject(Map<String, dynamic> map) {
    this._id = map['_id'];
    this.uid = map['uid'];
    this.user = map['user'];
    this.question = map['question'];
    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
    this.v = map['__v'];
  }
}