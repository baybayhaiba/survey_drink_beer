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
  bool _isSubmittingAll = false;

  Future<void> _autoSubmit(User user) async {
    final notifier = ref.read(userProvider.notifier);
    notifier.setSubmitting(true);

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
        // Gửi dữ liệu lên server
        final _ = await ref.read(submitSurvey(surveyResults).future);
        // await Future.delayed(const Duration(seconds: 1));
        notifier.setSubmitMessage("Submit thành công cho ${user.name}");
        notifier.nextUser(); // Tự động chuyển sang user tiếp theo

        // Nếu đang trong quá trình submit tất cả và chưa phải người dùng cuối, tiếp tục submit
        if (_isSubmittingAll &&
            ref.read(userProvider).users.length >
                ref.read(userProvider).currentUserIndex) {
          // Thêm thời gian chờ nhỏ để tránh gửi quá nhanh
          await Future.delayed(const Duration(milliseconds: 50));
          _autoSubmit(ref.read(userProvider).currentUser);
        } else if (_isSubmittingAll) {
          // Đã hoàn thành toàn bộ danh sách
          setState(() {
            _isSubmittingAll = false;
          });
          notifier.setSubmitMessage(
              "Đã hoàn thành gửi dữ liệu cho tất cả người dùng");
        }
      } catch (e) {
        notifier.setSubmitMessage("Submit thất bại: $e");
        // Dừng quá trình tự động nếu có lỗi
        setState(() {
          _isSubmittingAll = false;
        });
      } finally {
        notifier.setSubmitting(false);
      }
    } else {
      notifier.setSubmitMessage("Chưa đủ thông tin để submit");
      notifier.setSubmitting(false);
      // Dừng quá trình tự động nếu không đủ thông tin
      setState(() {
        _isSubmittingAll = false;
      });
    }
  }

  // Phương thức mới để bắt đầu quá trình gửi dữ liệu cho tất cả người dùng
  void _submitAllUsers() {
    final appState = ref.read(userProvider);
    if (appState.users.isEmpty) return;

    setState(() {
      _isSubmittingAll = true;
    });

    // Bắt đầu từ người dùng hiện tại
    _autoSubmit(appState.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(userProvider);

    ref.listen(userProvider, (previous, next) {
      if (previous?.submitMessage != next.submitMessage) {
        print("hahahaha ===> ${next.submitMessage}");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Thêm nút để gửi tất cả user
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _isSubmittingAll ? null : _submitAllUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: _isSubmittingAll
                  ? const Text("Đang gửi...")
                  : const Text("Gửi tất cả user"),
            ),
          ),
        ],
      ),
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
