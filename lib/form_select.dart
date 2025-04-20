import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/survey_acohol.dart';

class SurveyWidget extends ConsumerStatefulWidget {
  const SurveyWidget({super.key, this.onQuestionChanged});

  final Function(List<Question>)? onQuestionChanged;

  @override
  _SurveyWidgetState createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends ConsumerState<SurveyWidget> {
  @override
  Widget build(BuildContext context) {
    final surveyAcolholFuture = ref.watch(surveyAcolhol);

    return surveyAcolholFuture.when(
      data: (surveyData) {
        ///bao gồm 10 phần tử
        ///chỉ giữ là 1 và 9 10

        List<Question> questions = surveyData.questions;

        if (surveyData.questions.isNotEmpty) {
          questions = surveyData.questions.where(
            (value) {
              return value == surveyData.questions.first ||
                  value ==
                      surveyData.questions[surveyData.questions.length - 2] ||
                  value == surveyData.questions.last;
            },
          ).toList();

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            widget.onQuestionChanged?.call(questions);
          });
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return QuestionWidget(
              question: surveyData.questions[index],
              indexQuestion: index + 1,
              onAnswerSelected: (answer) {
                questions[index] = questions[index].copyWith(
                  selectedAnswer: answer,
                );

                widget.onQuestionChanged?.call(questions);

                return questions[index];
              },
            );
          },
        );
      },
      error: (error, stackTrace) => Text("Error => $error"),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Question Function(String) onAnswerSelected;
  final int indexQuestion;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.indexQuestion = 0,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late Question questionCurrent;

  @override
  void initState() {
    super.initState();
    questionCurrent = widget.question;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Câu ${widget.indexQuestion} : ${questionCurrent.description}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ...questionCurrent.answers.map((answer) {
              return RadioListTile<String>(
                title: Text(answer.description),
                value: answer.description,
                groupValue: questionCurrent.selectedAnswer,
                onChanged: (value) {
                  questionCurrent = widget.onAnswerSelected(value!);
                  setState(() {});
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
