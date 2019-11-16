class ContactUsRequest {
  final String subject;
  final String email;
  final String name;
  final String message;

  ContactUsRequest({this.subject, this.email, this.name, this.message});

  factory ContactUsRequest.fromJson(Map<String, dynamic> json) {
    return ContactUsRequest(
      subject: json['subject'],
      email: json['email'],
      name: json['name'],
      message: json['message'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["subject"] = subject;
    map["email"] = email;
    map["name"] = name;
    map["message"] = message;

    return map;
  }
}
