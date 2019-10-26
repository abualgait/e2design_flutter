import 'dart:async';

import 'package:e2_design/models/terms_response.dart';
import 'package:e2_design/repositories/base_repository.dart';

import '../api_response.dart';

class TermsBloc {
  BaseRepository _baseRepository;

  StreamController _streamController;

  StreamSink<ApiResponse<TermsResponse>> get termSink =>
      _streamController.sink;

  Stream<ApiResponse<TermsResponse>> get termStream =>
      _streamController.stream;

  TermsBloc() {
    _streamController = StreamController<ApiResponse<TermsResponse>>();
    _baseRepository = BaseRepository();
  }

  fetchTerms() async {
    termSink.add(ApiResponse.loading('Fetching Data'));
    try {
      TermsResponse response = await _baseRepository.fetchTerms();

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
