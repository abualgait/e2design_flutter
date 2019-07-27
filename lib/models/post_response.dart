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
}