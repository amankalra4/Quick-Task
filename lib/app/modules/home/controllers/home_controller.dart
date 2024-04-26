import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../exports.dart';

class HomeController extends GetxController {
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

  Future<List<Task>> fetchTasks(String? objectID) async {
    bool isConnected = await hasReliableInternetConnectivity();
    final url =
        '${ApiConstants.task}?where=%7B%20%20%22userPointer%22%3A%20%7B%20%22__type%22%3A%20%22Pointer%22%2C%20%22className%22%3A%20%22_User%22%2C%20%22objectId%22%3A%20%22$objectID%22%20%7D%20%7D';
    if (isConnected) {
      final EventObject eventObject =
          await httpGet(client: http.Client(), url: url);

      try {
        if (eventObject.id == EventConstants.requestSuccessful) {
          final DataList dataList = DataList.fromJson(
            json.decode(eventObject.response),
          );

          tasks = dataList.results?.map((task) {
            final DateTime? taskDueDate =
                DateTime.tryParse((task.taskDueDate ?? '').toString());
            if (taskDueDate == null) {
              throw Exception('Invalid taskDueDate format');
            }
            return Task(
                title: task.title,
                taskDueDate: taskDueDate,
                objectId: task.objectId,
                taskCompleted: task.taskCompleted,
                userPointer: task.userPointer);
          }).toList();
        } else {
          showToast(
            text: "Something went wrong",
            state: ToastStates.error,
          );
        }
      } catch (exception) {
        tasks = [];
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
      tasks = [];
    }
    return tasks ?? [];
  }
}
