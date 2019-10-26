class SignUpRequest {
  final String email;
  final String phone;
  final String first_name;
  final String last_name;
  final String password;

  SignUpRequest(
      {this.email, this.phone, this.first_name, this.last_name, this.password});

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      email: json['email'],
      phone: json['phone'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      password: json['password'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["phone"] = phone;
    map["first_name"] = first_name;
    map["last_name"] = last_name;
    map["password"] = password;

    return map;
  }
}
