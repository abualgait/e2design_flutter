import 'package:e2_design/models/activites_response.dart';
import 'package:e2_design/models/comment_response.dart';
import 'package:e2_design/models/contactus_response.dart';
import 'package:e2_design/models/like_response.dart';
import 'package:e2_design/models/normal_response.dart';
import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/models/onboarding_response.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/models/report_response.dart';
import 'package:e2_design/models/request/comment_request.dart';
import 'package:e2_design/models/request/contact_us_request.dart';
import 'package:e2_design/models/request/like_request.dart';
import 'package:e2_design/models/request/question_request.dart';
import 'package:e2_design/models/request/report_request.dart';
import 'package:e2_design/models/request/signup_request.dart';
import 'package:e2_design/models/signup_response.dart';
import 'package:e2_design/models/staticpage_response.dart';
import 'package:e2_design/network_manager/api_base_helper.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PostResponse> fetchPostList(int page) async {
    print(page.toString());
    final response = await _helper.get("questions?page=" + page.toString());
    return PostResponse.fromJson(response);
  }

  Future<PostDetailsObj> fetchPostDetails(String uid) async {
    final response = await _helper.get("question/" + uid);
    return PostDetailsResponse.fromJson(response).results;
  }

  Future<List<NotificationObj>> fetchNotificationsList() async {
    final response = await _helper.get("5d397bde2f00005b006ebb27");
    return NotificationResponse.fromJson(response).results;
  }

  Future<ActivitesResponse> fetchActivitiesss() async {
    final response = await _helper.get("5db1e99c3500007b00f54dd8");
    return ActivitesResponse.fromJson(response);
  }

  Future<SignUpResponse> signupWithEmail(SignUpRequest signUpRequest) async {
    final response =
        await _helper.post("signup_email", body: signUpRequest.toMap());
    return SignUpResponse.fromJson(response);
  }

  Future<SignUpResponse> signupWithMobile(SignUpRequest signUpRequest) async {
    final response =
        await _helper.post("signup_phone", body: signUpRequest.toMap());
    return SignUpResponse.fromJson(response);
  }

  Future<NormalResponse> verifyPhoneNumber(String verfication_code) async {
    final response = await _helper.get("verify_phone/" + verfication_code);
    return NormalResponse.fromJson(response);
  }

  Future<NormalResponse> createQuestions(
      QuestionRequest questionRequest) async {
    final response =
        await _helper.post("question", body: questionRequest.toMap());
    return NormalResponse.fromJson(response);
  }

  Future<CommentResponse> createComment(CommentRequest commentRequest) async {
    final response =
        await _helper.post("comment", body: commentRequest.toMap());
    return CommentResponse.fromJson(response);
  }

  Future<StaticResponse> fetchTerms() async {
    final response = await _helper.get("static_page/terms");
    return StaticResponse.fromJson(response);
  }

  Future<OnBoardingResponse> fetchOnBoarding() async {
    final response = await _helper.get("screens");
    return OnBoardingResponse.fromJson(response);
  }

  //api V2.0

  Future<StaticResponse> fetchPrivacy() async {
    final response = await _helper.get("static_page/privacy");
    return StaticResponse.fromJson(response);
  }

  Future<StaticResponse> fetchAboutUs() async {
    final response = await _helper.get("static_page/about-us");
    return StaticResponse.fromJson(response);
  }

  Future<LikeResponse> likeQuestion(LikeRequest likeRequest) async {
    final response = await _helper.post("like", body: likeRequest.toMap());
    return LikeResponse.fromJson(response);
  }

  Future<LikeResponse> unlikeQuestion(String id) async {
    final response = await _helper.delete("like_delete/" + id);
    return LikeResponse.fromJson(response);
  }

  Future<ReportResponse> report(ReportRequest reportRequest) async {
    final response =
    await _helper.post("report", body: reportRequest.toMap());
    return ReportResponse.fromJson(response);
  }

  Future<ContactResponse> contactus(ContactUsRequest contactUsRequest) async {
    final response =
    await _helper.post("contact_us/", body: contactUsRequest.toMap());
    return ContactResponse.fromJson(response);
  }

}
