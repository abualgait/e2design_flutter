
import 'normal_response.dart';

class ReportResponse extends NormalResponse {
  MyReport data;

  ReportResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return ReportResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, new MyReport.fromJson(json['data']));
  }
}


class MyReport {
  String _id;
  String uid;
  String reason;
  String user;
  String question;
  String comment;
  String createdAt;
  String updatedAt;

  int v;

  String get id => _id;

  MyReport.fromJson(Map<String, dynamic> json) {
    //_id = json['_id'];
    _id = json['_id'];
    uid = json['uid'];
    user = json['user'];

    reason = json['reason'];
    comment = json['comment'];

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

    map['reason'] = reason;
    map['comment'] = comment;

    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;

    map['__v'] = v;

    return map;
  }

  // Extract a Note object from a Map object
  MyReport.fromMapObject(Map<String, dynamic> map) {
    this._id = map['_id'];
    this.uid = map['uid'];
    this.user = map['user'];
    this.question = map['question'];

    this.reason = map['reason'];
    this.comment = map['comment'];

    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
    this.v = map['__v'];
  }
}