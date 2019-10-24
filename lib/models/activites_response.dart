class ActivitesResponse {
  List<dynamic> totalResults;
  List<ActivityObj> results;

  ActivitesResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['list'];
    if (json['list'] != null) {
      results = new List<ActivityObj>();
      json['list'].forEach((v) {
        results.add(new ActivityObj.fromJson(v));
      });
    }
  }
}

class ActivityObj {
  int id;
  String activity_title;
  String activity_time;
  String activity_type;
  String activity_image;

  ActivityObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity_title = json['activity_title'];
    activity_time = json['activity_time'];
    activity_type = json['activity_type'];
    activity_image = json['activity_image'];
  }
}
