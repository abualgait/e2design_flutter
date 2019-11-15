import 'normal_response.dart';

class PostDetailsResponse extends NormalResponse {
  PostDetailsObj results;

  PostDetailsResponse(
      int next_offset, bool status, String message, this.results)
      : super(next_offset, status, message);

  factory PostDetailsResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);

    return PostDetailsResponse(
        normalresponse.next_offset,
        normalresponse.status,
        normalresponse.message,
        new PostDetailsObj.fromJson(json['data']));
  }
}

class PostDetailsObj {
  PostDetailsObj() {}

  String _id;
  String uid;
  String post_txt;
  String post_img;
  String post_location;
  String details;

  // String post_comments;
  String post_time;

  // String post_stars;
  List<Comment> comments;

  String tag_1;
  String tag_2;
  String tag_3;

  String get id => _id;

  PostDetailsObj.fromJson(Map<String, dynamic> json) {
    tag_1 = json['tag_1'];
    tag_2 = json['tag_2'];
    tag_3 = json['tag_3'];
    _id = json['id'];
    uid = json['uid'];
    post_txt = json['question'];
    post_img = json['image'];
    post_location = json['location'];
    details = json['details'];
    // post_comments = json['post_comments'];
    post_time = json['created_at'];
    //  post_stars = json['post_stars'];
    comments = new List<Comment>();
    json['comments'].forEach((v) {
      comments.add(new Comment.fromJson(v));
    });
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['tag_1'] = tag_1;
    map['tag_2'] = tag_2;
    map['tag_3'] = tag_3;

    map['question'] = post_txt;
    map['details'] = details;
    map['image'] = post_img;
    map['location'] = post_location;
    //  map['post_comments'] = post_comments;
    map['created_at'] = post_time;
    // map['post_stars'] = post_stars;

    return map;
  }

  // Extract a Note object from a Map object
  PostDetailsObj.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.post_txt = map['question'];
    this.post_img = map['image'];

    this.tag_1 = map['tag_1'];
    this.tag_2 = map['tag_2'];
    this.tag_3 = map['tag_3'];

    this.details = map['details'];
    this.post_location = map['location'];
    // this.post_comments = map['post_comments'];
    this.post_time = map['created_at'];
    //this.post_stars = map['post_stars'];
  }
}

class Comment {
  String _id;
  String uid;
  bool correct;
  String question;
  String createdAt;
  String updatedAt;
  String comment;
  int v;

  String get id => _id;

  Comment.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    uid = json['uid'];
    correct = json['correct'];
    question = json['question'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    comment = json['comment'];
    v = json['__v'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['uid'] = uid;
    map['correct'] = correct;
    map['question'] = question;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['comment'] = comment;
    map['__v'] = v;

    return map;
  }

  // Extract a Note object from a Map object
  Comment.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.uid = map['uid'];
    this.correct = map['correct'];
    this.question = map['question'];
    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
    this.v = map['__v'];
  }
}
//class Comment {
//  int _id;
//  String comment_avatar;
//  String comment_name;
//  String comment_designation;
//  String comment_time;
//  String comment_percent;
//  String comment_rate;
//  String comment_txt;
//  String comment_likes;
//  String comment_comments;
//  String comment_share;
//
//  int get id => _id;
//
//  Comment.fromJson(Map<String, dynamic> json) {
//    _id = json['id'];
//    comment_avatar = json['comment_avatar'];
//    comment_name = json['comment_name'];
//    comment_designation = json['comment_designation'];
//    comment_time = json['comment_time'];
//    comment_percent = json['comment_percent'];
//    comment_rate = json['comment_rate'];
//    comment_txt = json['comment_txt'];
//    comment_likes = json['comment_likes'];
//    comment_comments = json['comment_comments'];
//    comment_share = json['comment_share'];
//  }
//
//  // Convert a Note object into a Map object
//  Map<String, dynamic> toMap() {
//    var map = Map<String, dynamic>();
//    if (id != null) {
//      map['id'] = _id;
//    }
//    map['comment_avatar'] = comment_avatar;
//    map['comment_name'] = comment_name;
//    map['comment_designation'] = comment_designation;
//    map['comment_time'] = comment_time;
//    map['comment_percent'] = comment_percent;
//    map['comment_rate'] = comment_rate;
//    map['comment_txt'] = comment_txt;
//    map['comment_likes'] = comment_likes;
//    map['comment_comments'] = comment_comments;
//    map['comment_share'] = comment_share;
//
//    return map;
//  }
//
//  // Extract a Note object from a Map object
//  Comment.fromMapObject(Map<String, dynamic> map) {
//    this._id = map['id'];
//    this.comment_avatar = map['comment_avatar'];
//    this.comment_name = map['comment_name'];
//    this.comment_designation = map['comment_designation'];
//    this.comment_time = map['comment_time'];
//    this.comment_percent = map['comment_percent'];
//    this.comment_rate = map['comment_rate'];
//    this.comment_txt = map['comment_txt'];
//    this.comment_likes = map['comment_likes'];
//    this.comment_comments = map['comment_comments'];
//    this.comment_share = map['comment_share'];
//  }
//}
