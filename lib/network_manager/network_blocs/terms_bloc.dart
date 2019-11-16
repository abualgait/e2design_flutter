import 'dart:async';

import 'package:e2_design/models/contactus_response.dart';
import 'package:e2_design/models/request/contact_us_request.dart';
import 'package:e2_design/models/staticpage_response.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class StaticBloc {
  BaseRepository _baseRepository;

  StreamController _streamController;

  StreamSink<ApiResponse<StaticResponse>> get termSink =>
      _streamController.sink;

  Stream<ApiResponse<StaticResponse>> get termStream =>
      _streamController.stream;

  StreamController _contactUsStreamController;

  StreamSink<ApiResponse<ContactResponse>> get contactusSink =>
      _contactUsStreamController.sink;

  Stream<ApiResponse<ContactResponse>> get contactusStream =>
      _contactUsStreamController.stream;

  StaticBloc() {
    _streamController = StreamController<ApiResponse<StaticResponse>>();
    _contactUsStreamController = StreamController<ApiResponse<ContactResponse>>.broadcast();
    _baseRepository = BaseRepository();
  }

  fetchTerms() async {
    termSink.add(ApiResponse.loading('Fetching Data'));
    try {
      StaticResponse response = await _baseRepository.fetchTerms();

      termSink.add(ApiResponse.completed(response));
    } catch (e) {
      termSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchAboutUs() async {
    termSink.add(ApiResponse.loading('Fetching Data'));
    try {
      StaticResponse response = await _baseRepository.fetchAboutUs();

      termSink.add(ApiResponse.completed(response));
    } catch (e) {
      termSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchPrivacy() async {
    termSink.add(ApiResponse.loading('Fetching Data'));
    try {
      StaticResponse response = await _baseRepository.fetchPrivacy();

      termSink.add(ApiResponse.completed(response));
    } catch (e) {
      termSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  postContactUs(ContactUsRequest contactUsRequest) async {
    contactusSink.add(ApiResponse.loading('Fetching Data'));
    try {
      ContactResponse response = await _baseRepository.contactus(contactUsRequest);

      contactusSink.add(ApiResponse.completed(response));
    } catch (e) {
      contactusSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _streamController?.close();
    _contactUsStreamController?.close();
  }
}
