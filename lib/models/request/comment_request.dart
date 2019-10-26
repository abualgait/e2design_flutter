class CommentRequest {
  final String comment;
  final String question_id;


  CommentRequest(
      {this.comment, this.question_id });

  factory CommentRequest.fromJson(Map<String, dynamic> json) {
    return CommentRequest(
      comment: json['comment'],
      question_id: json['question_id'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["comment"] = comment;
    map["question_id"] = question_id;


    return map;
  }
}
