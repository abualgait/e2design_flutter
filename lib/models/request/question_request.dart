class QuestionRequest {
  final String question;
  final String location;
  final String city;
  final String details;
  final String image;

  QuestionRequest(
      {this.question, this.location, this.city, this.details, this.image});

  factory QuestionRequest.fromJson(Map<String, dynamic> json) {
    return QuestionRequest(
      question: json['question'],
      location: json['location'],
      city: json['city'],
      details: json['details'],
      image: json['image'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["question"] = question;
    map["location"] = location;
    map["city"] = city;
    map["details"] = details;
    map["image"] = image;

    return map;
  }
}
