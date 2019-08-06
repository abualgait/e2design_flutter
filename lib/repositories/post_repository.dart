import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_base_helper.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Post>> fetchPostList() async {
    final response = await _helper.get("5d4953c03200008942600b31");
    return PostResponse.fromJson(response).results;
  }

  Future<List<NotificationObj>> fetchNotificationsList() async {
    final response = await _helper.get("5d397bde2f00005b006ebb27");
    return NotificationResponse.fromJson(response).results;
  }
}
