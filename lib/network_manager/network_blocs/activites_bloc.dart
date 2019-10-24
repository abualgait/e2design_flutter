import 'dart:async';

import 'package:e2_design/models/activites_response.dart';
import 'package:e2_design/repositories/base_repository.dart';
import 'package:e2_design/screens/activities_page.dart';

import '../api_response.dart';

class ActivitiesBloc {
  BaseRepository _baseRepository;

  StreamController _activitiesListController;

  StreamSink<ApiResponse<ActivitesResponse>> get activitiesListSink =>
      _activitiesListController.sink;

  Stream<ApiResponse<ActivitesResponse>> get activitiesListStream =>
      _activitiesListController.stream;

  ActivitiesBloc() {
    _activitiesListController =
        StreamController<ApiResponse<ActivitesResponse>>();
    _baseRepository = BaseRepository();
  }

  fetchActivitiesList(ACTIVITY_TYPES activity_types) async {
    activitiesListSink.add(ApiResponse.loading('Fetching Data'));
    try {
      ActivitesResponse response;

      switch (activity_types) {
        case ACTIVITY_TYPES.ALL:
          response = await _baseRepository.fetchActivitiesss();
          print("all");
          break;

        case ACTIVITY_TYPES.ASKED:
          response = await _baseRepository.fetchActivitiesss();
          print("asked");
          break;

        case ACTIVITY_TYPES.LIKED:
          response = await _baseRepository.fetchActivitiesss();
          print("liked");
          break;

        case ACTIVITY_TYPES.ANSWERED:
          response = await _baseRepository.fetchActivitiesss();
          print("answerd");
          break;
      }
      activitiesListSink.add(ApiResponse.completed(response));
    } catch (e) {
      activitiesListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _activitiesListController?.close();
  }
}
