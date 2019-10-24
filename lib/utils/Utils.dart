import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/post_response.dart';

List<Post> getListFromDynamic(List<dynamic> dynamicList) {
  List<Post> results;
  if (dynamicList != null) {
    results = new List<Post>();
    dynamicList.forEach((v) {
      results.add(new Post.fromJson(v));
    });
  }
  return results;
}
