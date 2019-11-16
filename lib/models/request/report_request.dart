class ReportRequest {
  final String user_id;
  final String question_id;
  final String comment_id;
  final String  reason;

  ReportRequest(
      {this.user_id, this.question_id ,this.comment_id,this.reason});

  factory ReportRequest.fromJson(Map<String, dynamic> json) {
    return ReportRequest(
      user_id: json['user_id'],
      question_id: json['question_id'],
      comment_id: json['comment_id'],
      reason: json['reason'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = user_id;
    map["question_id"] = question_id;
    map["comment_id"] = comment_id;
    map["reason"] = reason;


    return map;
  }
}
