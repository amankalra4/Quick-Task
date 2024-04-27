import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../exports.dart';

class TasksController extends GetxController {
  final GetStorage userData = GetStorage();
  Task? task;
  bool isLoading = false;
  bool taskCompleted = false;
  String? taskTitle;
  TextEditingController? titleController, contentController;
  late DateTime _dueDate;
  DateTime dateSelected = DateTime.now();

  DateTime get selectedDate => _dueDate;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    contentController = TextEditingController();
    _dueDate = DateTime.now();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    titleController?.dispose();
    contentController?.dispose();
  }

  Future<void> showCurrentTask() async {
    titleController!.text = task!.title!;
    _dueDate = task!.taskDueDate!;
  }

  bool validateInput() {
    bool validated = false;
    if (titleController!.text.isNotEmpty) {
      taskTitle = titleController!.text;
      validated = true;
    } else {
      validated = false;
    }
    return validated;
  }

  void updateDueDate(DateTime newDueDate) {
    _dueDate = newDueDate;
    update();
  }

  Future<bool?> createTask() async {
    bool? success;

    if (validateInput()) {
      isLoading = true;
      update();

      bool isConnected = await hasReliableInternetConnectivity();

      if (isConnected) {
        String? userObjectId = await getUserObjectIdFromSharedPreferences();

        if (userObjectId != null) {
          final EventObject? eventObject = await httpPost(
            client: http.Client(),
            url: ApiConstants.task,
            data: jsonEncode(<String, dynamic>{
              "taskTitle": taskTitle ?? "",
              "taskDueDate": _dueDate.toString(),
              "taskCompleted": false,
              "userPointer": {
                "__type": "Pointer",
                "className": "_User",
                "objectId": userObjectId,
              }
            }),
          );

          isLoading = false;
          update();

          try {
            switch (eventObject!.id) {
              case EventConstants.requestSuccessful:
                success = true;
                showToast(
                  text: "New task saved successfully",
                  state: ToastStates.success,
                );
                Get.offAll(() => HomeView());
                break;

              case EventConstants.requestInvalid:
                success = false;
                showToast(
                  text: "Invalid request",
                  state: ToastStates.error,
                );
                break;

              case EventConstants.requestUnsuccessful:
                showToast(
                  text: "Saving new task was not successful",
                  state: ToastStates.error,
                );
                break;

              default:
                showToast(
                  text: "Saving new task was not successful",
                  state: ToastStates.error,
                );
                success = null;
                break;
            }
          } catch (exception) {
            success = null;
          }
        } else {
          showToast(
            text: "User object ID not found in SharedPreferences",
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
    return success;
  }

  Future<bool?> deleteTask(String? objectId) async {
    bool? success;

    if (validateInput()) {
      isLoading = true;
      update();

      bool isConnected = await hasReliableInternetConnectivity();

      if (isConnected) {
        final EventObject eventObject =
            await httpDelete(client: http.Client(), objectId: objectId);

        isLoading = false;
        update();
        try {
          switch (eventObject.id) {
            case EventConstants.requestSuccessful:
              success = true;
              showToast(
                text: "Task deleted successfully",
                state: ToastStates.success,
              );
              Get.offAll(() => HomeView());
              break;

            case EventConstants.requestInvalid:
              success = false;
              showToast(
                text: "Invalid request",
                state: ToastStates.error,
              );
              break;

            case EventConstants.requestUnsuccessful:
              showToast(
                text: "Something went wrong",
                state: ToastStates.error,
              );
              break;

            default:
              showToast(
                text: "Deleting task was not successful",
                state: ToastStates.error,
              );
              success = null;
              break;
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
    return success;
  }

  Future<void> confirmDelete(BuildContext context, String? objectId) async {
    if (validateInput()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          content: const Text('Are you sure you want to delete the task?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteTask(objectId);
              },
              child:
                  const Text("DELETE", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("CANCEL", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }

  Future<bool?> updateTask(String? objectId, bool? taskCompleted) async {
    bool? success;

    if (validateInput()) {
      isLoading = true;
      update();

      bool isConnected = await hasReliableInternetConnectivity();

      if (isConnected) {
        String? userObjectId = await getUserObjectIdFromSharedPreferences();
        final EventObject? eventObject = await httpPut(
            client: http.Client(),
            url: ApiConstants.task,
            data: jsonEncode(<String, dynamic>{
              "taskTitle": taskTitle ?? "",
              "taskDueDate": _dueDate.toString(),
              "taskCompleted": taskCompleted,
              "userPointer": {
                "__type": "Pointer",
                "className": "_User",
                "objectId": userObjectId
              }
            }),
            objectId: objectId);

        isLoading = false;
        update();
        try {
          switch (eventObject!.id) {
            case EventConstants.requestSuccessful:
              success = true;
              showToast(
                text: task != null
                    ? "Task updated successfully"
                    : "New task saved successfully",
                state: ToastStates.success,
              );
              Get.offAll(() => HomeView());
              break;

            case EventConstants.requestInvalid:
              success = false;
              showToast(
                text: "Invalid request",
                state: ToastStates.error,
              );
              break;

            case EventConstants.requestUnsuccessful:
              success = false;
              break;

            default:
              showToast(
                text: task != null
                    ? "Updating new task was not successful"
                    : "Saving new task was not successful",
                state: ToastStates.error,
              );
              success = null;
              break;
          }
        } catch (exception) {
          success = null;
        }
      } else {
        showToast(
          text: "Your internet seems to be unstable",
          state: ToastStates.error,
        );
      }
    }
    return success;
  }

  Future<String?> getUserObjectIdFromSharedPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userObjectId');
  }
}
