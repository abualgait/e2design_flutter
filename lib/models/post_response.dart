import 'package:e2_design/utils/Utils.dart';

import 'normal_response.dart';

class PostResponse extends NormalResponse {
  List<Post> totalResults;
  List<Post> results;
  int pages;

  PostResponse(int next_offset, bool status, String message, this.results,this.pages)
      : super(next_offset, status, message);

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return PostResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, getListFromDynamic(json['data']),json['pages']);
  }
}

class Post {
  //int _id;
  String uid;
  var post_txt;
  String post_img;
  String post_location;

//  String post_comments;
  String post_time;

  // String post_stars;
  String status;
  String archive;

  //int get id => _id;

  Post.fromJson(Map<String, dynamic> json) {
//    _id = json['id'];
    uid = json['uid'];
    post_txt = json['question'];
    post_img = json['image'];
    post_location = json['location'];
    //post_comments = json['post_comments'];
    post_time = json['created_at'];
    // post_stars = json['post_stars'];
    status = json['status'];
    archive = json['archive'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
//    if (id != null) {
//      map['id'] = _id;
//    }
    map['uid'] = uid;
    map['question'] = post_txt;
    map['image'] = post_img;
    map['location'] = post_location;
    //map['post_comments'] = post_comments;
    map['created_at'] = post_time;
    //map['post_stars'] = post_stars;
    map['status'] = status;
    map['archive'] = archive;

    return map;
  }

  // Extract a Note object from a Map object
  Post.fromMapObject(Map<String, dynamic> map) {
    //this._id = map['id'];
    this.uid = map['uid'];
    this.post_txt = map['question'];
    this.post_img = map['image'];
    this.post_location = map['location'];
    //this.post_comments = map['post_comments'];
    this.post_time = map['created_at'];
    //  this.post_stars = map['post_stars'];
    this.status = map['status'];
    this.archive = map['archive'];
  }
}
