import 'normal_response.dart';

class TermsResponse extends NormalResponse {
  String data;

  TermsResponse(int next_offset, bool status, String message, this.data)
      : super(next_offset, status, message);

  factory TermsResponse.fromJson(Map<String, dynamic> json) {
    final normalresponse = NormalResponse.fromJson(json);
    return TermsResponse(normalresponse.next_offset, normalresponse.status,
        normalresponse.message, json['data'] == null ? "" : json['data']);
  }
}
