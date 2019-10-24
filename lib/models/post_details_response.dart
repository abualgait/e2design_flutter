import 'normal_response.dart';

class PostDetailsResponse extends NormalResponse {
  PostDetailsObj results;

  PostDetailsResponse(
      int next_offset, String status, String message, this.results)
      : super(next_offset, status, message);

  factory PostDetailsResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
//    if (json['post_details'] != null) {
//      results = new PostDetailsObj();
//      results = (new PostDetailsObj.fromJson(json['post_details']));
//    }

    return PostDetailsResponse(
        normalresponse.next_offset,
        normalresponse.status,
        normalresponse.message,
        new PostDetailsObj.fromJson(json['post_details']));
  }
}

class PostDetailsObj {
  PostDetailsObj() {}

  int _id;
  var post_txt;
  String post_img;
  String post_location;
  String post_comments;
  String post_time;
  String post_stars;
  List<Comment> comments;

  int get id => _id;

  PostDetailsObj.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    post_txt = json['post_txt'];
    post_img = json['post_img'];
    post_location = json['post_location'];
    post_comments = json['post_comments'];
    post_time = json['post_time'];
    post_stars = json['post_stars'];
    comments = new List<Comment>();
    json['comments_list'].forEach((v) {
      comments.add(new Comment.fromJson(v));
    });
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['post_txt'] = post_txt;
    map['post_img'] = post_img;
    map['post_location'] = post_location;
    map['post_comments'] = post_comments;
    map['post_time'] = post_time;
    map['post_stars'] = post_stars;

    return map;
  }

  // Extract a Note object from a Map object
  PostDetailsObj.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.post_txt = map['post_txt'];
    this.post_img = map['post_img'];
    this.post_location = map['post_location'];
    this.post_comments = map['post_comments'];
    this.post_time = map['post_time'];
    this.post_stars = map['post_stars'];
  }
}

class Comment {
  int _id;
  String comment_avatar;
  String comment_name;
  String comment_designation;
  String comment_time;
  String comment_percent;
  String comment_rate;
  String comment_txt;
  String comment_likes;
  String comment_comments;
  String comment_share;

  int get id => _id;

  Comment.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    comment_avatar = json['comment_avatar'];
    comment_name = json['comment_name'];
    comment_designation = json['comment_designation'];
    comment_time = json['comment_time'];
    comment_percent = json['comment_percent'];
    comment_rate = json['comment_rate'];
    comment_txt = json['comment_txt'];
    comment_likes = json['comment_likes'];
    comment_comments = json['comment_comments'];
    comment_share = json['comment_share'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['comment_avatar'] = comment_avatar;
    map['comment_name'] = comment_name;
    map['comment_designation'] = comment_designation;
    map['comment_time'] = comment_time;
    map['comment_percent'] = comment_percent;
    map['comment_rate'] = comment_rate;
    map['comment_txt'] = comment_txt;
    map['comment_likes'] = comment_likes;
    map['comment_comments'] = comment_comments;
    map['comment_share'] = comment_share;

    return map;
  }

  // Extract a Note object from a Map object
  Comment.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.comment_avatar = map['comment_avatar'];
    this.comment_name = map['comment_name'];
    this.comment_designation = map['comment_designation'];
    this.comment_time = map['comment_time'];
    this.comment_percent = map['comment_percent'];
    this.comment_rate = map['comment_rate'];
    this.comment_txt = map['comment_txt'];
    this.comment_likes = map['comment_likes'];
    this.comment_comments = map['comment_comments'];
    this.comment_share = map['comment_share'];
  }
}
