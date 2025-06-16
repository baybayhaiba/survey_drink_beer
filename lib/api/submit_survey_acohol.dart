import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_config.dart';

final submitSurvey =
    FutureProvider.family<dynamic, SurveyPostParams>((ref, param) async {
  Dio dio = ApiService().dio;

  // await Future.delayed(Duration(seconds: 3));

  final result = await dio.post(
    '/SurveySession/Al',
    data: {
      "address": param.address,
      "birthOfYear": param.birthOfYear,
      "district": param.district,
      "fullName": param.fullName,
      "gender": param.gender,
      "phone": param.phone,
      "ward": param.ward,
      "surveySession": param.surveySession.toJson(),
    },
  );

  return result.data;
});

// Parameters for the FutureProvider
class SurveyPostParams {
  final String address;
  final int birthOfYear;
  final String district;
  final String fullName;
  final int gender;
  final String phone;
  final String ward;
  final SurveySession surveySession;

  SurveyPostParams({
    required this.address,
    required this.birthOfYear,
    required this.district,
    required this.fullName,
    required this.gender,
    required this.phone,
    required this.ward,
    required this.surveySession,
  });
}

// Data Models (Optional but Recommended)
class SurveySessionResult {
  final String questionId;
  final String answerId;

  SurveySessionResult({required this.questionId, required this.answerId});

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "answerId": answerId,
      };
}

class SurveySession {
  final String questionTemplateId;
  final String result;
  final List<SurveySessionResult> surveySessionResults;
  final String userId;

  SurveySession({
    required this.questionTemplateId,
    required this.result,
    required this.surveySessionResults,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "questionTemplateId": questionTemplateId,
        "result": result,
        "surveySessionResults":
            surveySessionResults.map((e) => e.toJson()).toList(),
        "userId": userId,
      };
}
