class QuestionRequest {
  final String question;
  final String location;
  final String city;
  final String details;
  final String image;

  final String tag_1;
  final String tag_2;
  final String tag_3;
  final String user_id;

  QuestionRequest(
      {this.question,
      this.location,
      this.city,
      this.details,
      this.image,
      this.tag_1,
      this.tag_2,
      this.tag_3,
      this.user_id});

  factory QuestionRequest.fromJson(Map<String, dynamic> json) {
    return QuestionRequest(
      question: json['question'],
      location: json['location'],
      city: json['city'],
      details: json['details'],
      image: json['image'],
      tag_1: json['tag_1'],
      tag_2: json['tag_2'],
      tag_3: json['tag_3'],
      user_id: json['user_id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["question"] = question;
    map["location"] = location;
    map["city"] = city;
    map["details"] = details;
    map["image"] = image;

    map["tag_1"] = tag_1;
    map["tag_2"] = tag_2;
    map["tag_3"] = tag_3;
    map["user_id"] = user_id;

    return map;
  }
}
