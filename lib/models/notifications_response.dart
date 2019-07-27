class NotificationResponse {
  List<dynamic> totalResults;
  List<NotificationObj> results;

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['list'];
    if (json['list'] != null) {
      results = new List<NotificationObj>();
      json['list'].forEach((v) {
        results.add(new NotificationObj.fromJson(v));
      });
    }
  }
}

class NotificationObj {
  int id;
  String noti_title;
  String noti_body;

  NotificationObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noti_title = json['noti_title'];
    noti_body = json['noti_body'];
  }
}
