import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../exports.dart';

class TasksView extends StatefulWidget {
  final Task? currentTask;

  TasksView({Key? key, this.currentTask}) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TasksController controller = Get.put(TasksController());
  final GetStorage userData = GetStorage();
  late bool isSwitched;
  late FocusNode focusNode;
  late TextEditingController dateController;
  bool isTitleNotEmpty = false;

  @override
  void initState() {
    if (widget.currentTask != null &&
        widget.currentTask!.title != null &&
        widget.currentTask!.title!.isNotEmpty) {
      isSwitched = widget.currentTask!.taskCompleted!;
    } else {
      isSwitched = false;
    }
    super.initState();
    focusNode = FocusNode();
    controller.titleController!.addListener(titleChanged);
    if (widget.currentTask != null) {
      controller.task = widget.currentTask;
      controller.showCurrentTask();
    }
    dateController = TextEditingController();
    if (widget.currentTask != null &&
        widget.currentTask!.title != null &&
        widget.currentTask!.title!.isNotEmpty) {
      dateController = TextEditingController(
        text: controller.task?.taskDueDate != null
            ? DateFormat.yMMMd().format(controller.task!.taskDueDate!)
            : '',
      );
    } else {
      dateController = TextEditingController(
          text: DateFormat.yMMMd().format(DateTime.now()));
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  void titleChanged() {
    setState(() {
      isTitleNotEmpty = controller.titleController!.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.currentTask != null &&
                  widget.currentTask!.title != null &&
                  widget.currentTask!.title!.isNotEmpty)
              ? AppConstants.updateTaskTitle
              : AppConstants.taskTitle,
        ),
        actions: [
          if (widget.currentTask != null)
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.delete),
              ),
              onTap: () => controller.confirmDelete(
                  context, widget.currentTask!.objectId),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FormInput(
                  iLabel: 'Task Title',
                  iController: controller.titleController!,
                  iOptions: const <String>[],
                  onChanged: (value) {
                    setState(() {
                      isTitleNotEmpty = value.isNotEmpty;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              focusNode.requestFocus();
                              _selectDueDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                focusNode: focusNode,
                                controller: dateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: 'Select Due Date',
                                  border: UnderlineInputBorder(),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.currentTask != null &&
                    widget.currentTask!.title != null &&
                    widget.currentTask!.title!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: isSwitched ? Colors.green : Colors.red,
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSwitched = !isSwitched;
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              isSwitched ? 'Complete' : 'Incomplete',
                              style: TextStyle(
                                color: isSwitched ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: isTitleNotEmpty
                      ? () {
                          if (widget.currentTask != null &&
                              widget.currentTask!.title != null &&
                              widget.currentTask!.title!.isNotEmpty) {
                            controller.updateTask(
                                widget.currentTask?.objectId, isSwitched);
                          } else {
                            controller.createTask();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          (widget.currentTask != null &&
                                  widget.currentTask!.title != null &&
                                  widget.currentTask!.title!.isNotEmpty)
                              ? 'Update'
                              : 'Create',
                          style: isTitleNotEmpty
                              ? const TextStyle(
                                  color: Colors.white, fontSize: 16)
                              : const TextStyle(
                                  color: Colors.black45, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.currentTask == null ||
                  widget.currentTask!.title == null ||
                  widget.currentTask!.title!.isEmpty)
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Cancel',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      controller.updateDueDate(pickedDate);
      setState(() {
        dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    controller.titleController!.removeListener(titleChanged);
    super.dispose();
  }
}
