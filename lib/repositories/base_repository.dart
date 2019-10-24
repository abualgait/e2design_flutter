import 'package:e2_design/models/activites_response.dart';
import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_base_helper.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PostResponse> fetchPostList() async {
    final response = await _helper.get("5da9d51d310000880e4e0c2e");
    return PostResponse.fromJson(response);
  }

  Future<PostDetailsObj> fetchPostDetails(int id) async {
    final response = await _helper.get("5d98afbf3400005d00f48a90");
    return PostDetailsResponse.fromJson(response).results;
  }


  Future<List<NotificationObj>> fetchNotificationsList() async {
    final response = await _helper.get("5d397bde2f00005b006ebb27");
    return NotificationResponse.fromJson(response).results;
  }


  Future<ActivitesResponse> fetchActivitiesss() async {
    final response = await _helper.get("5db1e99c3500007b00f54dd8");
    return ActivitesResponse.fromJson(response);
  }
}
