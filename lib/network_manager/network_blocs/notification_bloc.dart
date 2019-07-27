import 'dart:async';

import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/repositories/post_repository.dart';

import '../api_response.dart';

class NotificationBloc {
  BaseRepository _baseRepository;

  StreamController _notificationListController;

  StreamSink<ApiResponse<List<NotificationObj>>> get notificationListSink =>
      _notificationListController.sink;

  Stream<ApiResponse<List<NotificationObj>>> get notificationListStream =>
      _notificationListController.stream;

  NotificationBloc() {
    _notificationListController = StreamController<ApiResponse<List<NotificationObj>>>();
    _baseRepository = BaseRepository();
    fetchNotificationList();
  }

  fetchNotificationList() async {
    notificationListSink.add(ApiResponse.loading('Fetching Data'));
    try {
      List<NotificationObj> posts = await _baseRepository.fetchNotificationsList();
      notificationListSink.add(ApiResponse.completed(posts));
    } catch (e) {
      notificationListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _notificationListController?.close();
  }
}