
import 'normal_response.dart';

class CommentResponse extends NormalResponse {
  MyComment data;

  CommentResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return CommentResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, new MyComment.fromJson(json['data']));
  }
}


class MyComment {
  String _id;
  String uid;
  bool correct;

  String createdAt;
  String updatedAt;

  int v;

  String get id => _id;

  MyComment.fromJson(Map<String, dynamic> json) {
    //_id = json['_id'];
    uid = json['uid'];
    correct = json['correct'];

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
    map['correct'] = correct;

    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;

    map['__v'] = v;

    return map;
  }

  // Extract a Note object from a Map object
  MyComment.fromMapObject(Map<String, dynamic> map) {
    this._id = map['_id'];
    this.uid = map['uid'];
    this.correct = map['correct'];

    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
    this.v = map['__v'];
  }
}