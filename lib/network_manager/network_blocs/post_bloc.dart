import 'dart:async';

import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/repositories/post_repository.dart';

import '../api_response.dart';

class PostBloc {
  BaseRepository _baseRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<List<Post>>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<List<Post>>> get movieListStream =>
      _movieListController.stream;

  PostBloc() {
    _movieListController = StreamController<ApiResponse<List<Post>>>();
    _baseRepository = BaseRepository();
    fetchPostList();
  }

  fetchPostList() async {
    movieListSink.add(ApiResponse.loading('Fetching Data'));
    try {
      List<Post> posts = await _baseRepository.fetchPostList();
      movieListSink.add(ApiResponse.completed(posts));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieListController?.close();
  }
}