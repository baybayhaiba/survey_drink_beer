import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

import 'dio_config.dart';

final surveyAcolhol =
    FutureProvider.autoDispose<AlcoholScreeningQuestionnaire>((ref) async {
  Dio dio = ApiService().dio;

  // await Future.delayed(Duration(seconds: 3));

  final result = await dio.get("/QuestionTemplate/02ed5f33-88bc-4341-aea3-2e49b5b47a9a");

  return AlcoholScreeningQuestionnaire.fromJson(result.data);
});



class AlcoholScreeningQuestionnaire {
  final String id;
  final String? description; // Có thể null
  final String title;
  final List<Question> questions;
  final List<SurveyResult> surveyResults;

  AlcoholScreeningQuestionnaire({
    required this.id,
    this.description, // Có thể null
    required this.title,
    required this.questions,
    required this.surveyResults,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description, // Tự động xử lý null
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
      'surveyResults': surveyResults.map((result) => result.toJson()).toList(),
    };
  }

  factory AlcoholScreeningQuestionnaire.fromJson(Map<String, dynamic> json) {
    return AlcoholScreeningQuestionnaire(
      id: json['id'],
      description: json['description'], // Tự động xử lý null
      title: json['title'],
      questions: (json['questions'] as List)
          .map((questionJson) => Question.fromJson(questionJson))
          .toList(),
      surveyResults: (json['surveyResults'] as List)
          .map((resultJson) => SurveyResult.fromJson(resultJson))
          .toList(),
    );
  }
}

class Question {
  final int order;
  final bool isMultipleChoice;
  final List<Answer> answers;
  final String id;
  final String description;
  final bool? isDeleted; // Có thể null
  final String? dateCreated; // Có thể null
  final String? dateUpdated; // Có thể null
  final String? selectedAnswer; // Có thể null

  copyWith({String? selectedAnswer}) {
    return Question(
      order: order,
      isMultipleChoice: isMultipleChoice,
      answers: answers,
      id: id,
      description: description,
      isDeleted: isDeleted,
      dateCreated: dateCreated,
      dateUpdated: dateUpdated,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }

  Question({
    required this.order,
    this.selectedAnswer, // Có thể null
    required this.isMultipleChoice,
    required this.answers,
    required this.id,
    required this.description,
    this.isDeleted, // Có thể null
    this.dateCreated, // Có thể null
    this.dateUpdated, // Có thể null
  });

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'isMultipleChoice': isMultipleChoice,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'id': id,
      'description': description,
      'isDeleted': isDeleted,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {

    final question = Question(
      order: json['order'],
      isMultipleChoice: json['isMultipleChoice'],
      answers: (json['answers'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList(),
      id: json['id'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      dateCreated: json['dateCreated'],
      dateUpdated: json['dateUpdated'],
    );

    return question.copyWith(selectedAnswer: question.answers.first.description);
  }
}

class Answer {
  final int score;
  final String id;
  final String description;
  final bool? isDeleted; // Có thể null
  final String? dateCreated; // Có thể null
  final String? dateUpdated; // Có thể null

  Answer({
    required this.score,
    required this.id,
    required this.description,
    this.isDeleted, // Có thể null
    this.dateCreated, // Có thể null
    this.dateUpdated, // Có thể null
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'id': id,
      'description': description,
      'isDeleted': isDeleted,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      score: json['score'],
      id: json['id'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      dateCreated: json['dateCreated'],
      dateUpdated: json['dateUpdated'],
    );
  }
}

class SurveyResult {
  final String id;
  final String? description; // Có thể null
  final int? fromScore; // Có thể null
  final int? toScore; // Có thể null

  SurveyResult({
    required this.id,
    this.description, // Có thể null
    this.fromScore, // Có thể null
    this.toScore, // Có thể null
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'fromScore': fromScore,
      'toScore': toScore,
    };
  }

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    return SurveyResult(
      id: json['id'],
      description: json['description'],
      fromScore: json['fromScore'],
      toScore: json['toScore'],
    );
  }
}
