class LikeRequest {
  final String user_id;
  final String question_id;


  LikeRequest(
      {this.user_id, this.question_id });

  factory LikeRequest.fromJson(Map<String, dynamic> json) {
    return LikeRequest(
      user_id: json['user_id'],
      question_id: json['question_id'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = user_id;
    map["question_id"] = question_id;


    return map;
  }
}
