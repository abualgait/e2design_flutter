import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_base_helper.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Post>> fetchPostList() async {
    final response = await _helper.get("5d979d973b00002d00c3177d");
    return PostResponse.fromJson(response).results;
  }

  Future<PostDetailsObj> fetchPostDetails(int id) async {
    final response = await _helper.get("5d98afbf3400005d00f48a90");
    return PostDetailsResponse.fromJson(response).results;
  }


  Future<List<NotificationObj>> fetchNotificationsList() async {
    final response = await _helper.get("5d397bde2f00005b006ebb27");
    return NotificationResponse.fromJson(response).results;
  }
}
