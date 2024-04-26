import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exports.dart';

class RegisterController extends GetxController {
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

  Future<bool?> createUser(String userName, String password) async {
    bool isConnected = await hasReliableInternetConnectivity();
    bool? success;

    if (isConnected) {
      final EventObject? eventObject = await httpPost(
        client: http.Client(),
        url: ApiConstants.users,
        data: jsonEncode(<String, dynamic>{
          "username": userName,
          "password": password,
        }),
        isUserApi: true,
      );

      if (eventObject != null) {
        final Map<String, dynamic> responseData =
            jsonDecode(eventObject.response);

        if (responseData.containsKey('objectId')) {
          final objectId = responseData['objectId'];
          await saveObjectIdToSharedPreferences(objectId);
          success = true;
          showToast(
            text: "Account created successfully",
            state: ToastStates.success,
          );
          Get.offAll(() => HomeView());
        } else {
          showToast(
            text: "Failed to create account",
            state: ToastStates.error,
          );
          success = false;
        }
      } else {
        showToast(
          text: "Something went wrong",
          state: ToastStates.error,
        );
        success = false;
      }
    } else {
      showToast(
        text: "Your internet seems to be unstable",
        state: ToastStates.error,
      );
      return false;
    }
    return success;
  }

  Future<void> saveObjectIdToSharedPreferences(String objectId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('userObjectId', objectId);
  }
}
