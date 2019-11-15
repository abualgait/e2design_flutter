class NormalResponse {
  int next_offset;
  bool status = true;
  String message;

  NormalResponse(this.next_offset, this.status, this.message);

  NormalResponse.fromJson(Map<String, dynamic> json) {
    next_offset = json['next_offset'];
    status = json['status_bool'];
    message = json['message'];
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['next_offset'] = next_offset;
    map['status'] = status;
    map['message'] = message;

    return map;
  }

  // Extract a Note object from a Map object
  NormalResponse.fromMapObject(Map<String, dynamic> map) {
    this.next_offset = map['next_offset'];
    this.status = map['status'];
    this.message = map['message'];
  }
}
