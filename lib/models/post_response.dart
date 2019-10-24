import 'normal_response.dart';
import 'package:e2_design/utils/Utils.dart';

class PostResponse extends NormalResponse {
  List<Post> totalResults;
  List<Post> results;

  PostResponse(int next_offset, String status, String message, this.results)
      : super(next_offset, status, message);

  factory PostResponse.fromJson(Map<String, dynamic> json) {

    final normalresponse = NormalResponse.fromJson(json);
    return PostResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, getListFromDynamic(json['list']));
  }
}

class Post {
  int _id;
  var post_txt;
  String post_img;
  String post_location;
  String post_comments;
  String post_time;
  String post_stars;

  int get id => _id;

  Post.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    post_txt = json['post_txt'];
    post_img = json['post_img'];
    post_location = json['post_location'];
    post_comments = json['post_comments'];
    post_time = json['post_time'];
    post_stars = json['post_stars'];
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
  Post.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.post_txt = map['post_txt'];
    this.post_img = map['post_img'];
    this.post_location = map['post_location'];
    this.post_comments = map['post_comments'];
    this.post_time = map['post_time'];
    this.post_stars = map['post_stars'];
  }
}
