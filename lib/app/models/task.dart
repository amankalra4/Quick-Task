class DataList {
  List<Task>? results;

  DataList({this.results});

  DataList.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Task>[];
      json['results'].forEach((v) {
        results!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String? title;
  DateTime? taskDueDate;
  String? objectId;
  bool? taskCompleted;
  late Map<String, dynamic> userPointer;

  Task(
      {this.title,
      this.taskDueDate,
      this.objectId,
      this.taskCompleted,
      required this.userPointer});

  Task.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'] ?? '';
    title = json['taskTitle'] ?? '';
    taskDueDate =
        DateTime.tryParse(json['taskDueDate'] ?? '') ?? DateTime.now();
    taskCompleted = json['taskCompleted'] ?? '';
    userPointer = json['userPointer'] ?? {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskDueDate'] = taskDueDate;
    data['title'] = title;
    data['objectId'] = objectId;
    data['taskCompleted'] = taskCompleted;
    data['userPointer'] = userPointer;
    return data;
  }
}
