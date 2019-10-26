import 'dart:async';

import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class PostBloc {
  BaseRepository _baseRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<PostResponse>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<PostResponse>> get movieListStream =>
      _movieListController.stream;

  PostBloc() {
    _movieListController = StreamController<ApiResponse<PostResponse>>();
    _baseRepository = BaseRepository();

  }

  fetchPostList(bool isFirstTime,int page) async {
    if (isFirstTime) movieListSink.add(ApiResponse.loading('Fetching Data'));
    try {
      PostResponse response = await _baseRepository.fetchPostList(page);
      movieListSink.add(ApiResponse.completed(response));

    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }



  dispose() {
    _movieListController?.close();
  }
}
