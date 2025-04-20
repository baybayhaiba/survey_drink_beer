import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_project/user.dart';

// Định nghĩa trạng thái của ứng dụng
class AppState {
  final List<User> users;
  final int currentUserIndex;
  final bool isSubmitting;
  final String? submitMessage;

  AppState({
    required this.users,
    this.currentUserIndex = 0,
    this.isSubmitting = false,
    this.submitMessage,
  });

  User get currentUser => users[currentUserIndex];

  AppState copyWith({
    List<User>? users,
    int? currentUserIndex,
    bool? isSubmitting,
    String? submitMessage,
  }) {
    return AppState(
      users: users ?? this.users,
      currentUserIndex: currentUserIndex ?? this.currentUserIndex,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitMessage: submitMessage ?? this.submitMessage,
    );
  }
}

class UserNotifier extends StateNotifier<AppState> {
  UserNotifier() : super(AppState(users: [])) {
    _loadUsersFromJson();
  }

  void _loadUsersFromJson() async {
    final jsonString = await rootBundle.loadString('assets/users.json');

    final List<dynamic> jsonData = jsonDecode(jsonString);
    final users = jsonData.map((data) {
      final random = Random();
      final year =
          1960 + random.nextInt(46); // 1960 -> 2005 (2005 - 1960 + 1 = 46)
      final month = 1 + random.nextInt(12); // 1 -> 12
      final day =
          1 + random.nextInt(28); // 1 -> 28 (để tránh lỗi ngày không hợp lệ)
      final born = DateTime(year, month, day);

      return User(
        name: data['ho_ten'],
        dateOfBirth: data['ngay_sinh'] != null
            ? DateTime.parse(data['ngay_sinh'])
            : born,
        gender: data['gioi_tinh'] == "Nam" ? "male" : "female",
        phoneNumber: data['so_cccd'].toString(),
        district: User.cities.first,
        ward: User.wards.first,
        address: data['noi_o_hien_nay'].toString(),
      );
    }).toList();
    state = state.copyWith(users: users);
  }

  void nextUser() {
    if (state.currentUserIndex < state.users.length - 1) {
      state = state.copyWith(currentUserIndex: state.currentUserIndex + 1);
    } else {
      state = state.copyWith(currentUserIndex: 0); // Quay lại user đầu tiên
    }
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void setSubmitMessage(String message) {
    state = state.copyWith(submitMessage: message);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppState>((ref) {
  return UserNotifier();
});
