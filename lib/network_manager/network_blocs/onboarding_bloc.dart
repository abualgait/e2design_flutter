import 'dart:async';

import 'package:e2_design/models/onboarding_response.dart';
import 'package:e2_design/models/terms_response.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class OnBoardingBloc {
  BaseRepository _baseRepository;

  StreamController _streamController;

  StreamSink<ApiResponse<OnBoardingResponse>> get termSink =>
      _streamController.sink;

  Stream<ApiResponse<OnBoardingResponse>> get boardStream =>
      _streamController.stream;

  OnBoardingBloc() {
    _streamController = StreamController<ApiResponse<OnBoardingResponse>>();
    _baseRepository = BaseRepository();
  }

  fetchOnBoarding() async {
    termSink.add(ApiResponse.loading('Fetching Data'));
    try {
      OnBoardingResponse response = await _baseRepository.fetchOnBoarding();

      termSink.add(ApiResponse.completed(response));
    } catch (e) {
      termSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _streamController?.close();
  }
}
