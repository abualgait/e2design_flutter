import 'dart:async';

import 'package:e2_design/models/like_response.dart';
import 'package:e2_design/models/normal_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/models/report_response.dart';
import 'package:e2_design/models/request/like_request.dart';
import 'package:e2_design/models/request/report_request.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class PostBloc {
  BaseRepository _baseRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<PostResponse>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<PostResponse>> get movieListStream =>
      _movieListController.stream;

  StreamController _likeStreamController;

  StreamSink<ApiResponse<LikeResponse>> get likeSink =>
      _likeStreamController.sink;

  Stream<ApiResponse<LikeResponse>> get likeStream =>
      _likeStreamController.stream;

  StreamController _unlikeStreamController;

  StreamSink<ApiResponse<NormalResponse>> get unlikeSink =>
      _unlikeStreamController.sink;

  Stream<ApiResponse<NormalResponse>> get unlikeStream =>
      _unlikeStreamController.stream;

  StreamController _reportStreamController;

  StreamSink<ApiResponse<ReportResponse>> get reportSink =>
      _reportStreamController.sink;

  Stream<ApiResponse<ReportResponse>> get reportStream =>
      _reportStreamController.stream;

  PostBloc() {
    _reportStreamController =
        StreamController<ApiResponse<ReportResponse>>.broadcast();
    _likeStreamController =
        StreamController<ApiResponse<LikeResponse>>.broadcast();
    _unlikeStreamController =
        StreamController<ApiResponse<NormalResponse>>.broadcast();
    _movieListController = StreamController<ApiResponse<PostResponse>>.broadcast();
    _baseRepository = BaseRepository();
  }

  fetchPostList(bool isFirstTime, int page) async {
    if (isFirstTime) movieListSink.add(ApiResponse.loading('Fetching Data'));

    try {
      PostResponse response = await _baseRepository.fetchPostList(page);
      movieListSink.add(ApiResponse.completed(response));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  likePost(LikeRequest likeRequest) async {
    //likeSink.add(ApiResponse.loading('Fetching Data'));
    try {
      LikeResponse response = await _baseRepository.likeQuestion(likeRequest);
      likeSink.add(ApiResponse.completed(response));
    } catch (e) {
      likeSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  unlikePost(String id) async {
//    likeSink.add(ApiResponse.loading('Fetching Data'));
    try {
      NormalResponse response = await _baseRepository.unlikeQuestion(id);
      unlikeSink.add(ApiResponse.completed(response));
    } catch (e) {
      unlikeSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  sendReport(ReportRequest reportRequest) async {
    try {
      NormalResponse response = await _baseRepository.report(reportRequest);
      reportSink.add(ApiResponse.completed(response));
    } catch (e) {
      reportSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _reportStreamController?.close();
    _movieListController?.close();
    _likeStreamController?.close();
    _unlikeStreamController?.close();
  }
}
