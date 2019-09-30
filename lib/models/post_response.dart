class PostResponse {
  List<dynamic> totalResults;
  List<Post> results;

  PostResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['list'];
    if (json['list'] != null) {
      results = new List<Post>();
      json['list'].forEach((v) {
        results.add(new Post.fromJson(v));
      });
    }
  }
}

class Post {
  int id;
  var post_txt;
  String post_img;
  String post_location;
  String post_comments;
  String post_time;
  String post_stars;
  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
//    if (id != null) {
//      map['id'] = id;
//    }
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
    // this.id = map['id'];
    this.post_txt = map['post_txt'];
    this.post_img = map['post_img'];
    this.post_location = map['post_location'];
    this.post_comments = map['post_comments'];
    this.post_time = map['post_time'];
    this.post_stars = map['post_stars'];
  }
}