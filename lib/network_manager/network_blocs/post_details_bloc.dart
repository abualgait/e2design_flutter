import 'dart:async';

import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class PostDetailsBloc {
  BaseRepository _baseRepository;

  StreamController _postdetailsListController;

  StreamSink<ApiResponse< PostDetailsObj>> get postdetailsSink =>
      _postdetailsListController.sink;

  Stream<ApiResponse< PostDetailsObj>> get postdetailsStream =>
      _postdetailsListController.stream;

  PostDetailsBloc() {
    _postdetailsListController = StreamController<ApiResponse<PostDetailsObj>>();
    _baseRepository = BaseRepository();

  }

  fetchPostDetailsList(String id) async {
    postdetailsSink.add(ApiResponse.loading('Fetching Data'));
    try {
      PostDetailsObj postDetailsResponse = await _baseRepository.fetchPostDetails(id);
      postdetailsSink.add(ApiResponse.completed(postDetailsResponse));
    } catch (e) {
      postdetailsSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _postdetailsListController?.close();
  }
}