import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exports.dart';

class LoginController extends GetxController {
  final GetStorage userData = GetStorage();

  final ScrollController listScrollController = ScrollController();

  bool isLoading = false;

  late String currentUserId;

  List<Task>? tasks = [];

  @override
  void onInit() {
    super.onInit();
    listScrollController.addListener(scrollListener);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  Future<void> userLogin(String userName, String password) async {
    bool isConnected = await hasReliableInternetConnectivity();

    if (isConnected) {
      try {
        final http.Response response = await http.get(
          Uri.parse(
              '${ApiConstants.parseUrl}${ApiConstants.login}?username=$userName&password=$password'),
          headers: constructHeaders(),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('objectId')) {
            final objectId = responseData['objectId'];
            await saveObjectIdToSharedPreferences(objectId);
            showToast(
              text: "Welcome $userName",
              state: ToastStates.success,
            );
            Get.offAll(() => HomeView());
          } else {
            showToast(
              text: "Failed to login",
              state: ToastStates.error,
            );
          }
        } else if (response.statusCode == 404) {
          showToast(
            text: "Invalid username/password",
            state: ToastStates.error,
          );
        } else {
          showToast(
            text: "Failed to login",
            state: ToastStates.error,
          );
        }
      } catch (exception) {
        showToast(
          text: "Something went wrong",
          state: ToastStates.error,
        );
      }
    } else {
      showToast(
        text: "Your internet seems to be unstable",
        state: ToastStates.error,
      );
    }
  }

  Future<void> saveObjectIdToSharedPreferences(String objectId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('userObjectId', objectId);
  }
}
