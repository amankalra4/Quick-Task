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

  late TextEditingController _dateController;

  @override
  void initState() {
    if (widget.currentTask != null &&
        widget.currentTask!.title != null &&
        widget.currentTask!.title!.isNotEmpty) {
      isSwitched = widget.currentTask!.taskCompleted!;
    }
    super.initState();
    if (widget.currentTask != null) {
      controller.task = widget.currentTask;
      controller.showCurrentTask();
    }
    _dateController = TextEditingController();
    _dateController =
        TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.taskTitle,
        ),
        actions: [
          widget.currentTask != null
              ? InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.delete),
                  ),
                  onTap: () => controller.confirmDelete(
                      context, widget.currentTask!.objectId),
                )
              : InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.clear),
                  ),
                  onTap: () => Get.back(),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormInput(
                iLabel: 'Title',
                iController: controller.titleController!,
                iOptions: const <String>[],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDueDate(context),
                    child: const Text('Select Due Date'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _dateController.text,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.currentTask != null &&
                  widget.currentTask!.title != null &&
                  widget.currentTask!.title!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Switch(
                      value: isSwitched,
                      onChanged: toggleSwitch,
                    ),
                    Text(
                      isSwitched ? 'Complete' : 'Incomplete',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.currentTask != null &&
                        widget.currentTask!.title != null &&
                        widget.currentTask!.title!.isNotEmpty) {
                      controller.updateTask(
                          widget.currentTask?.objectId, isSwitched);
                    } else {
                      controller.createTask();
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
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
    );
    if (pickedDate != null) {
      controller.updateDueDate(pickedDate);
      setState(() {
        _dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
