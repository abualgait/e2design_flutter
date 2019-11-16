
import 'normal_response.dart';

class ContactResponse extends NormalResponse {
  MyContact data;

  ContactResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return ContactResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, new MyContact.fromJson(json['data']));
  }
}


class MyContact {
  String _id;
  String subject;
  String name;
  String email;
  String message;

  String createdAt;
  String updatedAt;

  int v;

  String get id => _id;

  MyContact.fromJson(Map<String, dynamic> json) {
    //_id = json['_id'];
    _id = json['_id'];
    subject = json['subject'];
    name = json['name'];

    email = json['email'];
    message = json['message'];


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
    map['subject'] = subject;
    map['name'] = name;
    map['email'] = email;

    map['message'] = message;


    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;

    map['__v'] = v;

    return map;
  }

  // Extract a Note object from a Map object
  MyContact.fromMapObject(Map<String, dynamic> map) {
    this._id = map['_id'];
    this.subject = map['subject'];
    this.name = map['name'];
    this.email = map['email'];

    this.message = map['message'];


    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
    this.v = map['__v'];
  }
}