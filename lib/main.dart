import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_project/user.dart';
import 'package:uuid/uuid.dart';

import 'api/submit_survey_acohol.dart';
import 'api/survey_acohol.dart';
import 'app_state.dart';
import 'form_input.dart';
import 'form_select.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  List<Question> questions = [];

  Future<void> _autoSubmit(User user) async {
    final notifier = ref.read(userProvider.notifier);
    notifier.setSubmitting(true);

    return notifier.nextUser(); // Tự động chuyển sang user tiếp theo

    if (questions.isNotEmpty &&
        questions.every((q) => q.selectedAnswer != null)) {
      final questionId = questions.map((e) => e.id).toList();
      final answerId = questions.map((e) {
        final answerSelected = e.answers
            .firstWhere((element) => element.description == e.selectedAnswer);
        return answerSelected.id;
      }).toList();

      final surveyResults = SurveyPostParams(
        address: user.address,
        birthOfYear: user.dateOfBirth.year,
        district: user.district,
        fullName: user.name,
        gender: user.gender == "male" ? 0 : 1,
        phone: user.phoneNumber,
        ward: user.ward,
        surveySession: SurveySession(
          questionTemplateId: "02ed5f33-88bc-4341-aea3-2e49b5b47a9a",
          result: "",
          surveySessionResults: List.generate(
            questionId.length,
            (index) => SurveySessionResult(
              questionId: questionId[index],
              answerId: answerId[index],
            ),
          ),
          userId: const Uuid().v4(),
        ),
      );

      try {
        // final result = await ref.read(submitSurvey(surveyResults).future);
        await Future.delayed(const Duration(seconds: 1));
        notifier.setSubmitMessage("Submit thành công cho ${user.name}");
        notifier.nextUser(); // Tự động chuyển sang user tiếp theo
      } catch (e) {
        notifier.setSubmitMessage("Submit thất bại: $e");
      } finally {
        notifier.setSubmitting(false);
      }
    } else {
      notifier.setSubmitMessage("Chưa đủ thông tin để submit");
      notifier.setSubmitting(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(userProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (appState.users.isNotEmpty)
              ScreeningForm(
                key: ValueKey(appState.currentUser),
                user: appState.currentUser,
                onSubmit: _autoSubmit,
              ),
            SurveyWidget(
              onQuestionChanged: (question) {
                questions = question;
              },
            ),
            if (appState.isSubmitting)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            if (appState.submitMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(appState.submitMessage!),
              ),
          ],
        ),
      ),
    );
  }
}
